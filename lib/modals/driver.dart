import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Driver> drivers = [];

class Driver {
  final String userID;
  final String name;
  final String targa;
  final String phone;
  final String photo;
  final double rating;
  final double credit;
  LatLng cords;

  Driver(
      {this.userID,
      this.name,
      this.phone,
      this.targa,
      this.photo,
      this.credit,
      this.rating});
  factory Driver.fromMap(Map<String, dynamic> json) => new Driver(
      userID: json["userID"],
      name: json["name"],
      phone: json["phone"],
      targa: json["targa"],
      rating: json["rating"],
      credit: json["credit"]?.toDouble(),
      photo: json["photo"]);
  Map<String, dynamic> toMap() => {
        "userID": userID,
        "name": name,
        "phone": phone,
        "targa": targa,
        "rating": rating,
        "credit": credit,
        "photo": photo
      };

  void setCords(LatLng cord) {
    cords = cord;
  }

  @override
  String toString() {
    return "DriverID $userID Name: $name, phone: $phone";
  }
}
