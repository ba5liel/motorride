import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/util/formulas.dart';

class TripBloc {
  Trip trip;
  StreamSubscription<DocumentSnapshot> requestResponseStream;
  Future<void> request(Trip trip, Function accepted, Function denied) async {
//get the closest driver
//write a request to the database
    int _index = 0;
    DocumentReference newRequest =
        Firestore.instance.collection("requests").document();
    String requestid = newRequest.documentID;
    await newRequest
        .setData({"driverID": drivers[_index].userID, "trip": trip.toMap()});

    requestResponseStream = Firestore.instance
        .collection("requests")
        .document(requestid)
        .snapshots()
        .listen((event) async {
      if (event.data == null) return;
      Timer timeout = Timer.periodic(Config.requestRideTimeOut, (timer) async {
        _index++;
        if (_index >= drivers.length) {
          requestResponseStream.cancel();
          return denied();
        }
        await newRequest
            .setData({"driverID": drivers[_index].userID, "tip": trip.toMap()});
      });
      if (event.data["accepted"] == null) return;
      if (event.data["accepted"]) {
        requestResponseStream.cancel();
        timeout.cancel();
        accepted();
        return;
      }
      if (drivers.length == _index + 1) {
        requestResponseStream.cancel();
        timeout.cancel();
        return denied();
      }
      if (!event.data["accepted"]) {
        await newRequest.setData(
            {"driverID": drivers[_index].userID, "trip": trip.toMap()});
        timeout.cancel();
        _index++;
      }
    });
  }

  void sortDriverByShortestDistance(LatLng pickup) {
    drivers.sort((a, b) => MyFormulas.getDistanceFromLatLonInKm(pickup.latitude,
            pickup.longitude, a.cords.latitude, a.cords.longitude)
        .compareTo(MyFormulas.getDistanceFromLatLonInKm(pickup.latitude,
            pickup.longitude, b.cords.latitude, b.cords.longitude)));
  }

  getroute() {}
  call() {
    print(trip);
  }

  text() {}
}
