import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/modals/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/payload.dart';
import 'package:collection/collection.dart';

class NodeServer {
  IO.Socket _socketIO;
  StreamController<Map<String, dynamic>> joinedLocation =
      new StreamController<Map<String, dynamic>>();
  StreamController<Map<String, dynamic>> getJoinedLocation() => joinedLocation;
  StreamController<List> roomController = new StreamController<List>();
  StreamController<List> getRoomController() => roomController;

  List rooms;
  List prerooms = [];

  void initNode() {
    if (_socketIO == null) {
      print("NodeServer init\n\n");
      _socketIO = IO.io(Config.websocketurl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false, // optional
      });
    }
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!_socketIO.connected) {
        print("_socketIO.connect() -- called");
        _socketIO.connect();
      }
    });
    if (_socketIO.connect() != null) {
      print("NodeServer init success\n\n");
    } else {
      print("NodeServer init failed\n\n");
    }
    //Call init before doing anything with socket
    _socketIO.on("connect", (_) {
      print("Web socket Connected\n\n\n\n");
      sendLocation(currentUser.userID, preCenter);

      _socketIO.on("joined", (r) {
        print("======== Joined a socket group =========== ${unOrdDeepEq(rooms, prerooms)}");
        rooms = r["rooms"];
        if (!unOrdDeepEq(rooms, prerooms)) roomController.add(rooms);
        prerooms = rooms;
      });
      //Subscribe to an event to listen tor
      _socketIO.on('room_location', (jsonData) {
        //Convert the JSON data received into a Map
        Map<String, dynamic> data = jsonData;
        print('\t\troom_location\n');
        print(data);
        joinedLocation.add(data);
      });
      _socketIO.on('disconnect', (_) => print('disconnect\n\n\n'));
      _socketIO.on('fromServer', (_) => print(_));
    });
  }

  void sendLocation(String userId, LatLng cord, {bool keep = false}) {
    print("send location called\n\n\n\n\n");
    if (cord == null) return;
    _socketIO.emit('location',
        Payload.location(userId, cord.latitude, cord.longitude).toString());
    Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({"lat": cord.latitude, "lng": cord.longitude});
  }

  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
  void dispose() {
    joinedLocation.close();
    _socketIO.close();
  }
}
