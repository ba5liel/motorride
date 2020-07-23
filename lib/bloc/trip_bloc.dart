import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/util/formulas.dart';

class TripBloc {
  Trip trip;
  Stream<DocumentSnapshot> requestResponse;
  Future<void> request(
      LatLng pickup, String address, Function accepted, Function denied) async {
//get the closest driver
//write a request to the database

    int _index = 0;
    DocumentReference newRequest =
        Firestore.instance.collection("requests").document();
    String requestid = newRequest.documentID;

    requestResponse = Firestore.instance
        .collection("requests")
        .document(requestid)
        .snapshots();
    Timer timeout = Timer.periodic(Config.requestRideTimeOut, (timer) async {
      _index++;
      if (drivers.length == _index + 1) {
        requestResponse = null;
        return denied();
      }
      await newRequest.setData({
        "driverID": drivers[_index].userID,
        "address": address,
        ...currentUser.toMap(),
        "location": pickup.toJson()
      });
    });
    requestResponse.listen((event) async {
      if (event.data["accepted"] == null) return;
      if (event.data["accepted"]) {
        requestResponse = null;
        timeout.cancel();
        accepted();
        return;
      }
      if (drivers.length == _index + 1) {
        requestResponse = null;
        return denied();
      }
      await newRequest.setData({
        "driverID": drivers[_index].userID,
        "address": address,
        ...currentUser.toMap(),
        "location": pickup.toJson()
      });
      _index++;
    });
  }

  void sortDriverByShortestDistance(LatLng pickup) {
    drivers.sort((a, b) => MyFormulas.getDistanceFromLatLonInKm(pickup.latitude,
            pickup.longitude, a.cords.latitude, a.cords.longitude)
        .compareTo(MyFormulas.getDistanceFromLatLonInKm(pickup.latitude,
            pickup.longitude, b.cords.latitude, b.cords.longitude)));
  }

  getroute() {}
  call() {}
  text() {}
}
