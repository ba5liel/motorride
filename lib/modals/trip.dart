import 'package:flutter/material.dart';
import 'package:motorride/modals/driver.dart';

class Trip {
  final Driver driver;
  final double eTA;
  final String arravialETA;
  final String pickupAddress;
  final String destinationAddress;
  final int nubmersOfDrivers;
  final double amount;
  final double tripDistance;
  final String tripDistanceText;

  Trip(
      {this.driver,
      @required this.arravialETA,
      @required this.eTA,
      @required this.pickupAddress,
      @required this.destinationAddress,
      @required this.nubmersOfDrivers,
      @required this.tripDistance,
      @required this.tripDistanceText,
      @required this.amount});
  factory Trip.fromMap(Map<String, dynamic> json) => new Trip(
        driver: Driver.fromMap(json["driver"]),
        arravialETA: json["arravialETA"],
        eTA: json["eTA"],
        pickupAddress: json["pickUpAddress"],
        destinationAddress: json["destinationAddress"],
        nubmersOfDrivers: json["numbersOfDrivers"],
        tripDistance: json["tripDistance"],
        tripDistanceText: json["tripDistanceText"],
        amount: json["amount"],
      );
  Map<String, dynamic> toMap() => {
        "driver": driver.toMap(),
        "arravialETA": arravialETA,
        "eTA": eTA,
        "pickupAddress": pickupAddress,
        "destinationAddress": destinationAddress,
        "nubmersOfDrivers": nubmersOfDrivers,
        "tripDistance": tripDistance,
        "tripDistanceText": tripDistanceText,
        "amount": amount,
      };
  @override
  String toString() {
    return "arraivalETA $arravialETA amount: $amount, destination: $destinationAddress";
  }
}
