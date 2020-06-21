import 'dart:math' as Math;

class MyFormulas {
  static const R = 6371; // Radiu;s of the earth in km
  static const epsilon = 0.000001;

  static double getDistanceFromLatLonInKm(
      double lat1, double lon1, double lat2, double lon2) {
    double dLat = deg2rad(lat2 - lat1); // deg2rad below
    double dLon = deg2rad(lon2 - lon1);
    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    print('Direction: ${(c * 180) / Math.pi}');

    double d = R * c; // Distance in km
    print("Distance $d m");
    return d;
  }

  static double deg2rad(double deg) {
    return deg * (Math.pi / 180);
  }

  static double rad2deg(double rad) {
    return (rad / Math.pi) * 180;
  }
}
