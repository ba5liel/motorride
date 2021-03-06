import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/triphistory.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/services/service_locator.dart';
import 'package:motorride/util/formulas.dart';

class TripBloc {
  Trip trip;
  String requestid;
  DocumentReference newRequest;
  List _driversWithCredit = [];
  final Config _config = locator<Config>();
  Timer timeout;
  int index = 0;

  StreamSubscription<DocumentSnapshot> requestResponseStream;
  Future<void> request(Trip trip, Function(TripHistory) accepted,
      Function denied, Function(TripHistory) arrived) async {
//get the closest driver
//write a request to the database
    index = 0;
    if (_driversWithCredit.length == 0) {
      await newRequest.update({"driverID": null, "active": false});
      return denied();
    }
    newRequest = FirebaseFirestore.instance.collection("requests").doc();
    requestid = newRequest.id;
    TripHistory th = TripHistory(
        active: true,
        trip: trip..setDriver(_driversWithCredit[index]),
        tripID: requestid,
        driverID: _driversWithCredit[index].userID,
        userID: currentUser.userID);
    await newRequest.set(th.toMap());

    requestResponseStream = FirebaseFirestore.instance
        .collection("requests")
        .doc(requestid)
        .snapshots()
        .listen((event) async {
          Map eventdata = event.data();
      if (eventdata == null || eventdata["active"] == null) return;
      if (eventdata == null) return;
      print("\n\nnew Request Event ${event.data}");
      return await sendRequestToDriver(event, denied, arrived, th, accepted);
    });
  }

  Future sendRequestToDriver(
    DocumentSnapshot event,
    Function denied,
    Function(TripHistory) arrived,
    TripHistory th,
    Function(TripHistory) accepted,
  ) async {
    if (_driversWithCredit.length <= index) {
      requestResponseStream.cancel();
      timeout.cancel();
      await newRequest.update({"driverID": null, "active": false});
      return denied();
    }
    Map eventdata = event.data();
    if (eventdata["driverID"] == null) {
      return await ontoTheNextOne(denied, event, arrived, th, accepted);
    }
    if (timeout == null || !timeout.isActive) {
      print("Timeout setted \n\n\n\n");
      timeout = Timer(Config.requestRideTimeOut, () async {
      print("Timeout reached \n\n\n\n");
       return  await ontoTheNextOne(denied, event, arrived, th, accepted);
      });
    }
    if (eventdata["accepted"] == null) return;
    if (eventdata["accepted"]) {
      requestResponseStream.cancel();
      print("Timeout cancled \n\n\n\n");
      timeout.cancel();
      timeout = null;
      print("_driversWithCredit[0] ${_driversWithCredit[index]}");
      accepted(th..setPloys(eventdata["polys"]));
      return;
    }
    if (!eventdata["accepted"]) {
      print("${_driversWithCredit[index]} denied request");
      await ontoTheNextOne(denied, event, arrived, th, accepted);
    }
  }

  Future ontoTheNextOne(
      Function denied,
      DocumentSnapshot event,
      Function(TripHistory) arrived,
      TripHistory th,
      Function(TripHistory) accepted) async {
    index++;
    print("_index $index");
    if (index >= _driversWithCredit.length) {
      requestResponseStream.cancel();
      timeout.cancel();
      await newRequest.update({"driverID": null, "active": false});
      return denied();
    }
    timeout.cancel();
    timeout = null;
    await newRequest.set(
        {"driverID": _driversWithCredit[index].userID, "accepted": null});
    sendRequestToDriver(event, denied, arrived, th, accepted);
  }

  setDriversWithEnougCredit(double amount) {
    print("\n\n_config.orderFeeOrder ${_config.orderFeeOrder}");
    _driversWithCredit = drivers
        .where((element) =>
            element.credit != null &&
            element.credit >= (amount * _config.orderFeeOrder))
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
    newRequest.update({
      "cancled": true,
      "complete": false,
      "active": false,
      "reason": reason
    });
  }
}
