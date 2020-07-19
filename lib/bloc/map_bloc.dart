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
import 'package:flutter_google_places/flutter_google_places.dart';

LatLng preCenter = LatLng(9.0336617, 38.7512801);

class MapBloc with ChangeNotifier, NodeServer {
  MapBloc() {
    init();
    notifyListeners();
  }
  Location _location = new Location();
  List<Driver> _drivers = [];
  LatLng _currentLocation;
  List<Marker> _markers = List();
  bool _permission = false;
  ws.Prediction _prediction;
  List<Driver> get drivers => _drivers;
  List<Marker> get markers => _markers;
  LatLng get currentLocation => _currentLocation;
  String address = "unnamed road";

  GoogleMapController mapContoller;
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
        sendLocation(currentUser.userID, _currentLocation);
        _markers.removeWhere(
            (element) => element.markerId.value == currentUser.userID);
        _markers.add(new Marker(
            icon: BitmapDescriptor.fromBytes(
                await getBytesFromAsset("assets/images/user_place.png", 80)),
            position: _currentLocation,
            markerId: MarkerId(currentUser.name ?? currentUser.phone),
            infoWindow: InfoWindow(title: "You", onTap: () {})));
      }
    });

    
    getRoomController().stream.listen((rooms) async {
      print("======== Room Stream returned a value =========== $rooms");
      if (rooms != null && rooms.length > 0) {
        Firestore.instance
            .collection('drivers')
            .where("room", whereIn: rooms)
            .snapshots()
            .listen((docs) {
          docs.documents.forEach((doc) {
            print(
                "======== Documents Stream returned a value =========== ${doc.data}");
            int index = _drivers
                .indexWhere((element) => element.userID == doc.data["userID"]);
            LatLng newCords = new LatLng(doc.data["lat"], doc.data["lng"]);

            index == -1
                ? _drivers.add(new Driver.fromMap(doc.data)..setCords(newCords))
                : _drivers[index].setCords(newCords);
          });
        });

        BitmapDescriptor iconm = BitmapDescriptor.fromBytes(
            await getBytesFromAsset("assets/images/motor_icon.png", 80));
        _markers.clear();
        _markers.addAll(_drivers
            .map((Driver e) => new Marker(
                position: e.cords,
                icon: iconm,
                markerId: MarkerId(e.userID),
                infoWindow: InfoWindow(
                    title: e.name,
                    snippet: "${e.phone} ${e.targa}",
                    onTap: () {})))
            .toList());
        _markers.add(new Marker(
            icon: BitmapDescriptor.fromBytes(
                await getBytesFromAsset("assets/images/user_place.png", 80)),
            position: _currentLocation,
            markerId: MarkerId(currentUser.name ?? currentUser.phone),
            infoWindow: InfoWindow(title: "You", onTap: () {})));
        notifyListeners();
      }
    });
    _currentLocation = await getCurrentLocation();
    _markers.add(new Marker(
        icon: BitmapDescriptor.fromBytes(
            await getBytesFromAsset("assets/images/user_place.png", 80)),
        position: _currentLocation,
        markerId: MarkerId(currentUser.name ?? currentUser.phone),
        infoWindow: InfoWindow(title: "You", onTap: () {})));
    notifyListeners();
  }

  Future<void> changeLocationSetting(
      {LocationAccuracy accuracy, int interval}) async {
    await _location.changeSettings(accuracy: accuracy, interval: interval);
  }
   Future<void> goToCurrentLocation() async {
    mapContoller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 17.0, tilt: 90),
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

  void openAutoComplete(BuildContext context) async {
    try {
      _prediction = await PlacesAutocomplete.show(
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
        ws.GoogleMapsPlaces _places = new ws.GoogleMapsPlaces(
            apiKey: Config.googleMapApiKey); //Same API_KEY as above
        ws.PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(_prediction.placeId);

        address = _prediction.description;
        LatLng dest = new LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng);

        _markers.add((new Marker(
            position: dest,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            markerId: MarkerId(
                "${currentUser.name}dest" ?? "${currentUser.phone}dest"),
            infoWindow: InfoWindow(
                title: "Destination",
                onTap: () {
                  print("request driver");
                }))));
      }
    } catch (e, t) {
      print(e);
      print(t);
      throw e;
    }
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
}
