import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motorride/bloc/server_bloc.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/util/formulas.dart';
import 'package:google_maps_webservice/places.dart' as ws;
import 'package:google_maps_webservice/geocoding.dart' as gc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart' as gc;

LatLng preCenter = LatLng(9.0336617, 38.7512801);
enum SetMarketType { SHOW_PICKUP, SHOW_DESTINATION, SHOW_NOTHING }

class MapBloc with ChangeNotifier, NodeServer {
  MapBloc() {
    init();
    notifyListeners();
  }
  gc.Geolocator _geolocator = new gc.Geolocator();
  Location _location = new Location();
  List<Driver> _drivers = [];
  LatLng _currentLocation;
  LatLng _destination;
  String destinationAddress = "destination";
  LatLng _pickup;
  String pickupAddress = "your Location";
  List<Marker> _markers = List();
  bool _permission = false;
  ws.Prediction _prediction;
  List<Driver> get drivers => _drivers;
  List<Marker> get markers => _markers;
  LatLng get currentLocation => _currentLocation;
  String address = "unnamed road";
  double tilt;
  GoogleMapController mapContoller;
  SetMarketType showSetMarker = SetMarketType.SHOW_NOTHING;
  LatLng _cameraCenter;

  ws.GoogleMapsPlaces _places =
      new ws.GoogleMapsPlaces(apiKey: Config.googleMapApiKey);

  set setMapContoller(GoogleMapController c) {
    print('++++++++++GoogleMapController======== settted');
    mapContoller = c;
  }

  void init() async {
    print("MapBloc Initalized");
    preCenter = LatLng(9.0336617, 38.7512801);
    await changeLocationSetting(accuracy: LocationAccuracy.high, interval: 0);
    _currentLocation = await getCurrentLocation();
    //listen for my location change
    await sendLocation(currentUser.userID, _currentLocation);
    _location.onLocationChanged.listen((event) async {
      _currentLocation = LatLng(event.latitude, event.longitude);
      if (_currentLocation != null &&
          preCenter != null &&
          _currentLocation != preCenter &&
          MyFormulas.getDistanceFromLatLonInKm(
                  _currentLocation.latitude,
                  _currentLocation.longitude,
                  preCenter.latitude,
                  preCenter.longitude) >
              0.05) {
        await sendLocation(currentUser.userID, _currentLocation);
        address = (await _geolocator.placemarkFromCoordinates(
                _currentLocation.latitude, _currentLocation.longitude))[0]
            .name;
        print(address);
        _markers.removeWhere(
            (element) => element.markerId.value == currentUser.userID);
        await _addYouMarker();
      }
    });

    getRoomController().stream.listen((rooms) async {
      print("======== Room Stream returned a value =========== $rooms");
      if (rooms != null && rooms.length > 0) {
        Firestore.instance
            .collection('drivers')
            .where("room", whereIn: rooms)
            .snapshots()
            .listen((docs) async {
          print("CHange Detected in DATABase\n");
          _markers = [];
          docs.documents.forEach((doc) async {
            if (doc.data["online"] == false) return;
            int index = _drivers
                .indexWhere((element) => element.userID == doc.data["userID"]);
            LatLng newCords = new LatLng(doc.data["lat"], doc.data["lng"]);

            index == -1
                ? _drivers.add(new Driver.fromMap(doc.data)..setCords(newCords))
                : _drivers[index].setCords(newCords);
          });
          BitmapDescriptor iconm = BitmapDescriptor.fromBytes(
              await getBytesFromAsset("assets/images/motor_icon.png", 50));
          await _addYouMarker();
          _markers = [..._markers]..addAll(_drivers
              .map((Driver e) => new Marker(
                  zIndex: 9999,
                  position: e.cords,
                  icon: iconm,
                  markerId: MarkerId(e.userID),
                  infoWindow: InfoWindow(
                      title: e.name,
                      snippet: "${e.phone} ${e.targa}",
                      onTap: () {})))
              .toList());
          notifyListeners();
        });
      }
    });
    _currentLocation = await getCurrentLocation();
    await _addYouMarker();
    address = (await _geolocator.placemarkFromCoordinates(
            _currentLocation.latitude, _currentLocation.longitude))[0]
        .name;
    print(address);
    notifyListeners();
  }

  Future<void> changeLocationSetting(
      {LocationAccuracy accuracy, int interval}) async {
    await _location.changeSettings(accuracy: accuracy, interval: interval);
  }

  Future<void> goToCurrentLocation() async {
    tilt = tilt == 90 ? 0 : 90;
    mapContoller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 17.0, tilt: tilt),
      ),
    );
    print("goToCurrentLocation called notifyListeners()");
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData location;
    try {
      bool serviceStatus = await _location.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission =
            (await _location.requestPermission() == PermissionStatus.granted);
        print("Permission: $_permission");
        if (_permission) {
          location = await _location.getLocation();
          print(location);
          return LatLng(location.latitude, location.longitude);
        }
      } else {
        bool serviceStatusResult = await _location.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          return getCurrentLocation();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
      } else if (e.code == 'SERVICE_STATUS_ERROR') {}
      //location = null;
    }
    return null;
  }

  void openAutoCompleteFrom(BuildContext context) async {
    try {
      _prediction = await PlacesAutocomplete.show(
        logo: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickup = _currentLocation;
                setPickUp();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe8f0fe),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.my_location,
                          color: Color(0xff1a73e8),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Your Location'),
                        Divider(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                choosePickUpLocationOnMap();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe8eaed),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.map,
                          color: Color(0xff3c4043),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Choose on Map',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onError: (e) {
          print("Error-e\n\n\n");
          print(e.hasNoResults);
          print(e.errorMessage);
        },
        context: context,
        apiKey: Config.googleMapApiKey,
        mode: Mode.overlay, // Mode.overlay
        language: "en",
        components: [ws.Component(ws.Component.country, "et")],
      );
      if (_prediction != null) {
        //Same API_KEY as above
        ws.PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(_prediction.placeId);

        pickupAddress = _prediction.description;
        _pickup = new LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng);
        await setPickUp();
        notifyListeners();
      }
    } catch (e, t) {
      print(e);
      print(t);
    }
  }

  void openAutoCompleteTo(BuildContext context) async {
    try {
      _prediction = await PlacesAutocomplete.show(
        logo: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                chooseDestinationLocationOnMap();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe8eaed),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.map,
                          color: Color(0xff3c4043),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Choose on Map',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onError: (e) {
          print("Error-e\n\n\n");
          print(e.hasNoResults);
          print(e.errorMessage);
        },
        context: context,
        apiKey: Config.googleMapApiKey,
        mode: Mode.overlay, // Mode.overlay
        language: "en",
        components: [ws.Component(ws.Component.country, "et")],
      );
      if (_prediction != null) {
        ws.PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(_prediction.placeId);

        destinationAddress = _prediction.description;
        _destination = new LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng);
        setDestination();
      }
    } catch (e, t) {
      print(e);
      print(t);
      throw e;
    }
  }

  Future<void> setPickUp() async {
    print("setPick up Called");
    _markers.removeWhere((element) => element.markerId.value == "pickup");

    _markers = [..._markers]..add(new Marker(
        zIndex: 9999,
        position: _pickup,
        icon: BitmapDescriptor.fromBytes(
            await getBytesFromAsset("assets/images/pickup.png", 100)),
        markerId: MarkerId("pickup"),
        infoWindow: InfoWindow(
            title: "Pick Up",
            snippet: "Your Pick Up location",
            onTap: () {
              print("request driver");
            })));
    mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
        boundsFromLatLngList([
          _currentLocation,
          _pickup,
          if (_destination != null) _destination
        ]),
        100));
    pickupAddress = (await _geolocator.placemarkFromCoordinates(
            _currentLocation.latitude, _currentLocation.longitude))[0]
        .name;
    notifyListeners();
  }

  Future<void> setDestination() async {
    _markers.removeWhere((element) => element.markerId.value == "destination");
    _markers = [..._markers]..add(new Marker(
        zIndex: 9999,
        position: _destination,
        icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(
            "assets/images/user_place_destination4.png", 100)),
        markerId: MarkerId("destination"),
        infoWindow: InfoWindow(
            title: "Destination",
            onTap: () {
              print("request driver");
            })));
    mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
        boundsFromLatLngList([
          _currentLocation,
          _destination,
          if (_pickup != null) _destination
        ]),
        100));
    destinationAddress = (await _geolocator.placemarkFromCoordinates(
            _currentLocation.latitude, _currentLocation.longitude))[0]
        .name;
    notifyListeners();
  }

  void setCameraCenter(LatLng pos) {
    _cameraCenter = pos;
  }

  void setChooseOnMap() async {
    print("setChooseOnMap");
    if (showSetMarker == SetMarketType.SHOW_PICKUP) {
      print("pick up choosen");
      _pickup = _cameraCenter;
      showSetMarker = SetMarketType.SHOW_NOTHING;
      await setPickUp();
    }
    if (showSetMarker == SetMarketType.SHOW_DESTINATION) {
      print("Destination choosen");
      _destination = _cameraCenter;
      showSetMarker = SetMarketType.SHOW_NOTHING;
      await setDestination();
    }
  }

  void choosePickUpLocationOnMap() {
    showSetMarker = SetMarketType.SHOW_PICKUP;
    notifyListeners();
  }

  void chooseDestinationLocationOnMap() {
    showSetMarker = SetMarketType.SHOW_DESTINATION;
    notifyListeners();
  }

  void closeChooseOnMap() {
    showSetMarker = SetMarketType.SHOW_NOTHING;
    notifyListeners();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  Future<Marker> _addYouMarker() async {
    Marker user = new Marker(
        zIndex: 999,
        icon: BitmapDescriptor.fromBytes(
            await getBytesFromAsset("assets/images/user_place.png", 80)),
        position: _currentLocation,
        markerId: MarkerId(currentUser.name ?? currentUser.phone),
        infoWindow: InfoWindow(title: "You", onTap: () {}));
    _markers.add(user);
    return user;
  }
}
