import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/user.dart';

class Trip {
  final Driver driver;
  final User user;
  final double eTA;
  final String arravialETA;
  final String pickupAddress;
  final String destinationAddress;
  final int nubmersOfDrivers;
  final double amount;
  final double tripDistance;
  final String tripDistanceText;
  final LatLng pickup;
  final LatLng destination;

  Trip(
      {this.driver,
      @required this.user,
      @required this.arravialETA,
      @required this.eTA,
      @required this.pickupAddress,
      @required this.destinationAddress,
      @required this.nubmersOfDrivers,
      @required this.tripDistance,
      @required this.tripDistanceText,
      @required this.pickup,
      @required this.destination,
      @required this.amount});
  factory Trip.fromMap(Map<String, dynamic> json) => new Trip(
        driver: Driver.fromMap(json["driver"]),
        user: User.fromMap(json["user"]),
        arravialETA: json["arravialETA"],
        eTA: json["eTA"],
        pickupAddress: json["pickUpAddress"],
        destinationAddress: json["destinationAddress"],
        nubmersOfDrivers: json["numbersOfDrivers"],
        tripDistance: json["tripDistance"],
        pickup: LatLng.fromJson(json["pick"]),
        destination: LatLng.fromJson(json["destination"]),
        tripDistanceText: json["tripDistanceText"],
        amount: json["amount"],
      );
  Map<String, dynamic> toMap() => {
        "driver": driver == null ? null : driver.toMap(),
        "user": user.toMap(),
        "arravialETA": arravialETA,
        "eTA": eTA,
        "pickupAddress": pickupAddress,
        "destinationAddress": destinationAddress,
        "nubmersOfDrivers": nubmersOfDrivers,
        "tripDistance": tripDistance,
        "tripDistanceText": tripDistanceText,
        "pickup": pickup.toJson(),
        "destination": destination.toJson(),
        "amount": amount,
      };
  @override
  String toString() {
    return "arraivalETA $arravialETA amount: $amount, destination: $destinationAddress";
  }
}
