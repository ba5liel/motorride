import 'package:motorride/modals/triphistory.dart';

User currentUser;

class User {
  final String userID;
  String name;
  String phone;
  String photo;
  double rating;
  TripHistory inProgressTrip;
  List<TripHistory> tripHistories = [];
  User({
    this.userID,
    this.name,
    this.phone,
    this.photo,
    this.rating,
    this.inProgressTrip,
    this.tripHistories,
  });
  factory User.fromMap(Map<String, dynamic> json) {
    print("User.fromMap");
    List<dynamic> thl = json["tripHistories"] ?? [];
    print("${thl.length} ");
    thl.removeWhere((element) => element == null);
    print("${thl.length} ");
    return new User(
        userID: json["userID"],
        name: json["name"],
        phone: json["phone"],
        inProgressTrip: json["inProgressTrip"] == null
            ? null
            : TripHistory.fromMap(json["inProgressTrip"]),
        tripHistories: thl.length == 0
            ? []
            : thl.map((e) => TripHistory.fromMap(e)).toList(),
        photo: json["photo"],
        rating: json["rating"]);
  }
  factory User.fromMapCompact(Map<String, dynamic> json) => new User(
      userID: json["userID"],
      name: json["name"],
      phone: json["phone"],
      photo: json["photo"],
      rating: json["rating"]);
  Map<String, dynamic> toMap() => {
        "userID": userID,
        "name": name,
        "phone": phone,
        "photo": photo,
        "rating": rating,
        "inProgressTrip":
            inProgressTrip != null ? inProgressTrip.toMap() : null,
        "tripHistories": tripHistories != null && tripHistories.length != 1
            ? tripHistories.map((e) => e?.toMap()).toList()
            : [],
      };
  Map<String, dynamic> toMapCompact() => {
        "userID": userID,
        "name": name,
        "phone": phone,
        "rating": rating,
        "photo": photo
      };
  void setName(String fname, String lname) {
    name = fname + " " + lname;
  }

  void setPhone(String newPhone) {
    phone = newPhone;
  }

  void setPhoto(String newPhoto) {
    photo = newPhoto;
  }

  void setRating(double newRating) {
    rating = newRating;
  }

  void addHistory(TripHistory history) {
    tripHistories.add(history);
  }

  void setInProgressTrip(TripHistory history) {
    inProgressTrip = history;
  }

  @override
  String toString() {
    return "userID $userID Name: $name, phone: $phone";
  }
}
