import 'package:intl/intl.dart';

class Formater {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  String formatDatetime(Duration seconds) {
    String time = seconds.inDays == 0 ? "" : "${seconds.inDays}d ";
    time += seconds.inHours == 0 ? "" : "${seconds.inHours-(24*seconds.inDays)}h ";
    time += seconds.inMinutes == 0 ? "" : "${seconds.inMinutes-(60*seconds.inHours)}m ";
    time += seconds.inSeconds == 0 ? "" : "${seconds.inSeconds-(60*seconds.inMinutes)}s";
    return time;
  }
  String formatDistance(double d) {
    int km = d ~/ 1000;
    int m = (((d / 1000) - km.toDouble()) * 1000).toInt();
    String dis = km == 0 ? "" : "${km}km ";
    dis += m == 0 ? "" : "${m}m";
    return dis;
  }
}
