import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/config/configs.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

class NodeServer {
  StreamController<List> roomController = new StreamController<List>();
  StreamController<List> getRoomController() => roomController;

  List rooms;
  List prerooms = [];
  void sendLocation(String userId, LatLng cord) async {
    print(cord);
    print("send location called\n\n\n\n\n");
    try {
      http.Response res = await http.post("${Config.baseUrl}/getroom", body: {
        "lat": cord.latitude.toString(),
        "lng": cord.longitude.toString()
      });
      print(res.body);
      Map<String, dynamic> room = json.decode(res.body);
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

  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
}
