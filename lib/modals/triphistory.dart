import 'package:motorride/modals/trip.dart';

class TripHistory {
  final String tripID;
  final bool accepted;
  final bool cancled;
  final bool active;
  TRIPPHASES phase = TRIPPHASES.FROMLOCATIONTOPICKUP;
  final bool completed;
  final String driverID;
  final String userID;
  List<dynamic> polys;
  final Trip trip;
  TripHistory(
      {this.accepted,
      this.tripID,
      this.active,
      this.cancled,
      this.completed,
      this.driverID,
      this.userID,
      this.phase,
      this.polys,
      this.trip});
  factory TripHistory.fromMap(Map<String, dynamic> json) => new TripHistory(
      tripID: json["tripID"],
      cancled: json["cancled"],
      accepted: json["accepted"],
      active: json["active"],
      completed: json["complete"],
      driverID: json["driverID"],
      phase: json["phase"] == null || json["phase"] == 0
          ? TRIPPHASES.FROMLOCATIONTOPICKUP
          : TRIPPHASES.FROMLOCATIONTODESTINATION,
      userID: json["userID"],
      polys: json["polys"],
      trip: Trip.fromMap(json["trip"]));
  Map<String, dynamic> toMap() => {
        "tripID": tripID,
        "accepted": accepted,
        "cancled": cancled,
        "name": active,
        "complete": completed,
        "driverID": driverID,
        "userID": userID,
        "phase": phase == TRIPPHASES.FROMLOCATIONTODESTINATION ? 1 : 0,
        "polys": polys,
        "trip": trip != null ? trip.toMap() : null
      };
  void setPloys(List<dynamic> p) {
    polys = p;
  }

  @override
  String toString() {
    return "TripHistoryID $tripID completed: $completed, trip: $trip";
  }
}
