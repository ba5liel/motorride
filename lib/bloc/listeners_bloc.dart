import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motorride/modals/user.dart';

class MyListeners {
  StreamSubscription<QuerySnapshot> driversStream;
  StreamSubscription<DocumentSnapshot> driverTripStream;

  void listenToDrivers(List<String> rooms, Function(QuerySnapshot) callback) {
    driversStream = Firestore.instance
        .collection('drivers')
        .where("room", whereIn: rooms)
        .snapshots()
        .listen(callback);
  }

  void listenToTripDriver(Function(DocumentSnapshot) callback) {
    driverTripStream = Firestore.instance
        .collection('drivers')
        .document(currentUser.inProgressTrip.trip.driver.userID)
        .snapshots()
        .listen(callback);
  }

  void closeDriverListerner() {
    print("========Closing drivers Listeners================");
    if (driversStream != null) driversStream.cancel();
  }

  void closeDriverTripListerner() {
    print("========Closing driverTripStream Listeners================");
    if (driverTripStream != null) driverTripStream.cancel();
  }
}
