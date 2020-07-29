import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:motorride/util/alerts.dart';

class NodeServer {
  StreamController<List> roomController =
      new StreamController<List>();

  Dio dio = new Dio();
  List rooms;
  List prerooms = [];
  Future<void> sendLocation(
      String userId, LatLng cord, BuildContext context) async {
    print(cord);
    print("send location called\n\n\n\n\n");
    try {
      Response res = await dio.post("${Config.baseUrl}/getallrooms",
          data: {
            "lat": cord.latitude.toString(),
            "lng": cord.longitude.toString()
          },
          options: Options(contentType: "application/x-www-form-urlencoded"));
      print(res.data);
      Map<String, dynamic> room = res.data;
      rooms = room["rooms"];
      if (!unOrdDeepEq(rooms, prerooms)) roomController.add(rooms);
      prerooms = rooms;
      if (!room["error"])
        Firestore.instance.collection('users').document(userId).updateData({
          "lat": cord.latitude,
          "lng": cord.longitude,
          "rooms": room["rooms"]
        });
    } catch (e) {
      print(e);
      Alerts.showPromptDialog(context, "No Internet Connection!",
          "No Internet Connection, have you turned on Internet", () {
        Navigator.pop(context);
        sendLocation(userId, cord, context);
      });
    }
  }

  Future<Map<String, dynamic>> calculateETA(
      LatLng origin, LatLng destination) async {
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&language=en&key=${Config.googleMapApiKey}");
    Map<String, dynamic> data = response.data;
    print(data);
    if (data["status"] != "OK") {
      throw Error();
    }
    List<dynamic> row = data["rows"];
    return row[0]["elements"][0];
  }

  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
}
