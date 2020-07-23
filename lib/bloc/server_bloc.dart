import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

class NodeServer {
  StreamController<List> roomController = new StreamController<List>();
  StreamController<List> getRoomController() => roomController;
  Dio dio = new Dio();
  List rooms;
  List prerooms = [];
  Future<void> sendLocation(String userId, LatLng cord) async {
    print(cord);
    print("send location called\n\n\n\n\n");
    try {
      FormData formData = new FormData.fromMap(
          {"lat": cord.latitude.toString(), "lng": cord.longitude.toString()});

      Response res =
          await dio.post("${Config.baseUrl}/getallrooms", data: formData);
      print(res.data);
      Map<String, dynamic> room = json.decode(res.data);
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
    }
  }

  Future<Map<String, dynamic>> calculateETA(
      LatLng origin, LatLng destination) async {
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=${Config.googleMapApiKey}");
    Map<String, dynamic> data = json.decode(response.data);
    print(data);
    if (data["status"] != "OK") {
      throw Error();
    }
    List<Map<String, dynamic>> row = data["row"];
    return  row[0]["elements"][0];
  }

  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
}
