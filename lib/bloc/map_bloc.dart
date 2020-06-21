import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motorride/bloc/server_bloc.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/util/formulas.dart';

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

  LatLng get center => _center;
  List<Driver> get drivers => _drivers;
  Completer<GoogleMapController> get completer => _completer;
  List<Marker> get markers => _markers;
  LatLng get currentLocation => _currentLocation;

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
    getJoinedLocation().stream.listen((Map<String, dynamic> data) {
      int index = _drivers.indexWhere((element) => element.id == data["id"]);
      LatLng newCords = new LatLng(data["lat"], data["lng"]);
      index == -1
          ? _drivers.add(new Driver(data["id"])..setCords(newCords))
          : _drivers[index].setCords(newCords);
      _markers = _drivers.map((e) => new Marker(
        position: e.cords,
        markerId: MarkerId(e.id),
        infoWindow: InfoWindow(title: "Driver", onTap: (){
          print("request driver");
        })
      ));
      notifyListeners();
    });
    _center = _currentLocation;
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
}
