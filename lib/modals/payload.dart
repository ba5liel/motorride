import 'dart:convert';

class Payload {
  final String cmd;
  final dynamic param;
  Payload({this.cmd, this.param});
  factory Payload.fromMap(Map<String, dynamic> json) => new Payload(
        cmd: json["cmd"],
        param: json["param"],
      );
  factory Payload.location(String userId, double lat, double long, {bool keep}) =>
      new Payload(
          cmd: "location", param: {"id": userId, "lat": lat, "long": long, "keep": keep??false});
  Map<String, dynamic> toMap() => {"cmd": cmd, "param": param};
  @override
  String toString() {
    return json.encode(toMap());
  }
}
