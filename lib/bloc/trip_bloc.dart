import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/triphistory.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/util/formulas.dart';

class TripBloc {
  Trip trip;
  String requestid;
  DocumentReference newRequest;
  List _driversWithCredit = [];
  StreamSubscription<DocumentSnapshot> requestResponseStream;
  Future<void> request(Trip trip, Function(TripHistory) accepted,
      Function denied, Function(TripHistory) arrived) async {
//get the closest driver
//write a request to the database
    int _index = 0;
    newRequest = Firestore.instance.collection("requests").document();
    requestid = newRequest.documentID;
    TripHistory th = TripHistory(
        active: true,
        trip: trip..setDriver(_driversWithCredit[_index]),
        tripID: requestid,
        driverID: _driversWithCredit[_index].userID,
        userID: currentUser.userID);
    await newRequest.setData(th.toMap());
    requestResponseStream = Firestore.instance
        .collection("requests")
        .document(requestid)
        .snapshots()
        .listen((event) async {
      print("\n\nnew Request Event ${event.data}");
      if (event.data == null) return;
      /*  Timer timeout = Timer.periodic(Config.requestRideTimeOut, (timer) async {
        _index++;
        if (_index >= _driversWithCredit.length) {
          requestResponseStream.cancel();
          return denied();
        }
        await newRequest
            .setData({"driverID": _driversWithCredit[_index].userID, "tip": trip.toMap()});
      }); */
      if (event.data["accepted"] == null) return;
      if (event.data["accepted"]) {
        requestResponseStream.cancel();
        //timeout.cancel();
        print("_driversWithCredit[0] ${_driversWithCredit[0]}");
        accepted(th..setPloys(event.data["polys"]));
        return;
      }
      if (_driversWithCredit.length == _index + 1) {
        requestResponseStream.cancel();
        //timeout.cancel();
        return denied();
      }
      if (!event.data["accepted"]) {
        await newRequest.updateData({
          "driverID": _driversWithCredit[_index].userID,
          "trip": trip.toMap()
        });
        //timeout.cancel();
        _index++;
      }
      if (event.data["phase"] == 1) {
        arrived(th
          ..setPloys(event.data["polys"])
          ..setPhase(TRIPPHASES.FROMLOCATIONTODESTINATION));
      }
    });
  }

  setDriversWithEnougCredit(double amount) {
    _driversWithCredit = drivers
        .where((element) =>
            element.credit != null &&
            element.credit > (amount * Config.orderFeeOrder))
        .toList();
  }

  void sortDriverByShortestDistance(LatLng pickup, double amount) {
    drivers.sort((a, b) => MyFormulas.getDistanceFromLatLonInKm(pickup.latitude,
            pickup.longitude, a.cords.latitude, a.cords.longitude)
        .compareTo(MyFormulas.getDistanceFromLatLonInKm(pickup.latitude,
            pickup.longitude, b.cords.latitude, b.cords.longitude)));
    setDriversWithEnougCredit(amount);
  }

  void cancleTrip(String reason) {
    newRequest.updateData({
      "cancled": true,
      "complete": false,
      "active": false,
      "reason": reason
    });
  }

  getroute() {}
  call() {
    print(trip);
  }

  text() {}
}
