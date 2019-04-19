import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
class RoomBloc extends Object{

//  FirestoreProvider _firestoreProvider = FirestoreProvider() ;

  BuildContext _context ;
  final _roomPressed = StreamController<int>.broadcast() ;
  final _initRooms = StreamController<bool>.broadcast() ;
  final _scrollRooms = StreamController<bool>.broadcast() ;
  final _addedRoom = StreamController<RoomInfo>.broadcast() ;
  final _roomList = FirestoreProvider().roomList;
  final _roomFinding = StreamController<RoomInfo>.broadcast() ;
  final _enterRoom = StreamController<RoomInfo>.broadcast() ;
  final _roomMessages = FirestoreProvider().roomMessages;

//  final _roomEntered = FirestoreProvider().enterRoom ;
  RoomInfo feedPageRoomInfo;
  RoomInfo chatPageRoomInfo;

  Stream<int> get roomPressed => _roomPressed.stream ;
  Stream<bool> get initRooms => _initRooms.stream ;
  Stream<bool> get scrollRooms => _scrollRooms.stream ;
  Stream<RoomInfo> get addedRoom => _addedRoom.stream ;
  Stream<QuerySnapshot> get roomList => _roomList(feedPageRoomInfo) ;
  Stream<RoomInfo> get roomFinding => _roomFinding.stream ;
  Stream<RoomInfo> get enterRoom => _enterRoom.stream ;
  Stream<QuerySnapshot> get roomMessages => _roomMessages(chatPageRoomInfo) ;
/*
searching stream 만들어서 searching block icon 눌렸을 때 list block stream 바꿔줌
 */

  Function(int) get setRoomPressed => _roomPressed.sink.add ;
  Function(bool) get setInitRooms => _initRooms.sink.add ;
  Function(bool) get setScrollRooms => _scrollRooms.sink.add ;
  Function(RoomInfo) get registerRoom => FirestoreProvider().registerRoom;
  Function(RoomInfo) get setRoomFinding => _roomFinding.sink.add ;
  Function(RoomInfo) get setEnterRoom => _enterRoom.sink.add ;

  RoomBloc(){

    enterRoom.listen((RoomInfo roomInfo){
      print(roomInfo.roomName) ;
      chatPageRoomInfo = roomInfo ;
    },onError: (error) {
      print("room finding error occured");
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text("Error!"),
      )
      ) ;
    }
    );

    roomFinding.listen((RoomInfo roomInfo){
      print(roomInfo.roomName) ;
      feedPageRoomInfo = roomInfo;
    },onError: (error) {
      print("room finding error occured");
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text("Error!"),
      )
      ) ;
    }
    );
  }

  dispose(){
    _roomPressed.close() ;
    _initRooms.close() ;
    _scrollRooms.close() ;
    _addedRoom.close() ;
    _roomFinding.close() ;
    _enterRoom.close() ;

  }

}