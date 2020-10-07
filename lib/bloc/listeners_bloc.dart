import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motorride/modals/user.dart';

class MyListeners {
  StreamSubscription<QuerySnapshot> driversStream;
  StreamSubscription<DocumentSnapshot> driverTripStream;

  void listenToDrivers(List<dynamic> rooms, Function(QuerySnapshot) callback) {
    driversStream = FirebaseFirestore.instance
        .collection('drivers')
        .where("room", whereIn: rooms)
        .where("available", isEqualTo: true)
        .snapshots()
        .listen(callback);
  }

  void listenToTripDriver(Function(DocumentSnapshot) callback) {
    driverTripStream = FirebaseFirestore.instance
        .collection('drivers')
        .doc(currentUser.inProgressTrip.driverID)
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
