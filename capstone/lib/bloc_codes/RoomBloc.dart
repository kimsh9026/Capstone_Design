import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/RoomInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/fire_base_codes/FirestoreProvider.dart';
class RoomBloc extends Object{

  BuildContext _context ;
  final _roomPressed = StreamController<int>.broadcast() ;
  final _initRooms = StreamController<bool>.broadcast() ;
  final _scrollRooms = StreamController<bool>.broadcast() ;
  final _addedRoom = StreamController<RoomInfo>.broadcast() ;
  final _roomList = FirestoreProvider().roomList;
  final _roomFinding = StreamController<RoomInfo>.broadcast() ;
  final _isFinding = StreamController<bool>.broadcast() ;
  RoomInfo roomInfo ;

  Stream<int> get roomPressed => _roomPressed.stream ;
  Stream<bool> get initRooms => _initRooms.stream ;
  Stream<bool> get scrollRooms => _scrollRooms.stream ;
  Stream<RoomInfo> get addedRoom => _addedRoom.stream ;
  Stream<QuerySnapshot> get roomList => _roomList(roomInfo) ;
  Stream<RoomInfo> get roomFinding => _roomFinding.stream ;
  Stream<bool> get isFinding => _isFinding.stream ;

/*
searching stream 만들어서 searching block icon 눌렸을 때 list block stream 바꿔줌
 */

  Function(int) get setRoomPressed => _roomPressed.sink.add ;
  Function(bool) get setInitRooms => _initRooms.sink.add ;
  Function(bool) get setScrollRooms => _scrollRooms.sink.add ;
  Function(RoomInfo) get registerRoom => FirestoreProvider().registerRoom;
  Function(RoomInfo) get setRoomFinding => _roomFinding.sink.add ;
  Function(bool) get isFInding => _isFinding.sink.add ;

  //해결필요
//  Function(Map<String,dynamic>) get setRoomInfo =>  Firestore.instance.collection('roomInfo').add ;

  RoomBloc(){
    roomPressed.listen((int roomNumber){

    }, onError: (error){
      print("room pressed error occured") ;
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text("Error!"),
      )
      );
    }
    ) ;
    roomFinding.listen((RoomInfo roomInfo){
      print(roomInfo.roomName) ;
      this.roomInfo = roomInfo;
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
  }

}