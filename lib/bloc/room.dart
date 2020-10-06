import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/util/formulas.dart';
import 'package:s2geometry/s2geometry.dart' as s2;

class CellRooms {
  static List<String> getallrooms(LatLng latlng, radius) {
    final List<double> bearing = [0, 45, 90, 135, 180, 225, 270, 315, 360];
    List<String> cells = [];
    cells.add((s2.S2CellId.fromLatLng(
            (s2.S2LatLng.fromDegrees(latlng.latitude, latlng.longitude))))
        .parent(11)
        .toToken());
    for (int i = 0; i < bearing.length; i++) {
      LatLng cord = findLatAndLngFromB(latlng, radius, bearing[i]);
      String key = s2.S2CellId.fromLatLng(
              (s2.S2LatLng.fromDegrees(cord.latitude, cord.longitude)))
          .parent(11)
          .toToken();
      if (cells.indexOf(key) == -1) {
        cells.add(key);
      }
    }
    print(cells);
    return cells;
  }

  static String getCell(LatLng latlng) {
    print((s2.S2CellId.fromLatLng(
            (s2.S2LatLng.fromDegrees(latlng.latitude, latlng.longitude))))
        .parent(11)
        .toToken());
    return (s2.S2CellId.fromLatLng(
            (s2.S2LatLng.fromDegrees(latlng.latitude, latlng.longitude))))
        .parent(11)
        .toToken();
  }

  static LatLng findLatAndLngFromB(LatLng cord, double d, double dir) {
    final double r = 6371; // Radius of the earth in km
    final double epsilon = 0.000001;
    double b = MyFormulas.deg2rad(dir);
    double ar = d / r;
    double la1 = MyFormulas.deg2rad(cord.latitude);
    double lo1 = MyFormulas.deg2rad(cord.longitude);
    double lo2;
    double la2 = asin(sin(la1) * cos(ar) + cos(lo1) * sin(ar) * cos(b));
    if (cos(la1) == 0 || cos(la1).abs() < epsilon) {
      // Endpoint a pole
      lo2 = lo1;
    } else {
      lo2 = ((lo1 - asin((sin(b) * sin(ar)) / cos(la1)) + pi) % (2 * pi)) - pi;
    }
    return new LatLng(MyFormulas.rad2deg(la2), MyFormulas.rad2deg(lo2));
  }
}
