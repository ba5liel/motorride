import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  final String id;
  LatLng cords;
  Driver(this.id);
  void setCords(LatLng cord){
    cords = cord;
  }
}