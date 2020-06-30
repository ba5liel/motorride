import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
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
    initNode();
  }
  Completer<GoogleMapController> _completer = Completer();
  Location _location = new Location();
  List<Driver> _drivers = [];
  LatLng _center;
  LatLng _currentLocation;
  List<Marker> _markers = List();
  bool _permission = false;
  ws.Prediction _prediction;
  LatLng get center => _center;
  List<Driver> get drivers => _drivers;
  Completer<GoogleMapController> get completer => _completer;
  List<Marker> get markers => _markers;
  LatLng get currentLocation => _currentLocation;
  String address = "unnamed road";
  void init() async {
    print("MapBloc Initalized");
    preCenter = LatLng(9.0336617, 38.7512801);
    await changeLocationSetting(accuracy: LocationAccuracy.high, interval: 0);
    _currentLocation = await getCurrentLocation();
    //listen for my location change
    _location.onLocationChanged.listen((event) {
      _currentLocation = LatLng(event.latitude, event.longitude);
      _center = _currentLocation;
      if (_center != null &&
          preCenter != null &&
          _center != preCenter &&
          MyFormulas.getDistanceFromLatLonInKm(_center.latitude,
                  _center.longitude, preCenter.latitude, preCenter.longitude) >
              10) notifyListeners();
    });

    //listen for driver location
    getJoinedLocation().stream.listen((Map<String, dynamic> data) async {
      int index = _drivers.indexWhere((element) => element.id == data["id"]);
      LatLng newCords = new LatLng(data["lat"], data["lng"]);
      index == -1
          ? _drivers.add(new Driver(data["id"])..setCords(newCords))
          : _drivers[index].setCords(newCords);
      BitmapDescriptor iconm = BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/images/driver_marker.png", 110));
      _markers = _drivers
          .map((Driver e) => new Marker(
              position: e.cords,
              icon: iconm,
              markerId: MarkerId(e.id),
              infoWindow: InfoWindow(
                  title: "Driver",
                  onTap: () {
                    print("request driver");
                  })))
          .toList();
      _markers.add(new Marker(
          position: _center,
          markerId: MarkerId(currentUser.name ?? currentUser.phone),
          infoWindow: InfoWindow(
              title: "You",
              onTap: () {
                print("request driver");
              })));
      notifyListeners();
    });

    _currentLocation = await getCurrentLocation();
    _center = _currentLocation;
    _markers.add(new Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: _center,
        markerId: MarkerId(currentUser.name ?? currentUser.phone),
        infoWindow: InfoWindow(
            title: "You",
            onTap: () {
              print("request driver");
            })));
    notifyListeners();
  }

  Future<void> changeLocationSetting(
      {LocationAccuracy accuracy, int interval}) async {
    await _location.changeSettings(accuracy: accuracy, interval: interval);
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
      print("\n\n\n\n");
      print(_prediction);
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
