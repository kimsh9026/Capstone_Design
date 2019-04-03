import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
class RoomBloc extends Object{

  BuildContext _context ;
  final _roomPressed = StreamController<int>.broadcast() ;
  final _initRooms = StreamController<bool>.broadcast() ;
  final _scrollRooms = StreamController<bool>.broadcast() ;
  final _addRoom = StreamController<bool>.broadcast() ;
  final _roomInfo = Firestore.instance.collection('roomInfo').snapshots() ;

  Stream<int> get roomPressed => _roomPressed.stream ;
  Stream<bool> get initRooms => _initRooms.stream ;
  Stream<bool> get scrollRooms => _scrollRooms.stream ;
  Stream<bool> get addRoom => _addRoom.stream ;
  Stream<QuerySnapshot> get roomInfo => _roomInfo ;


  Function(int) get setRoomPressed => _roomPressed.sink.add ;
  Function(bool) get setInitRooms => _initRooms.sink.add ;
  Function(bool) get setScrollRooms => _scrollRooms.sink.add ;
  Function(bool) get setAddRoom => _addRoom.sink.add ;
  
  //해결필요
  Function(Map<String,dynamic>) get setRoomInfo =>  Firestore.instance.collection('roomInfo').add ;

  RoomBloc(){
    roomPressed.listen((int roomNumber){

    }, onError: (error){
      print("error occured") ;
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text("Error!"),
      )
      );
    }
    ) ;
  }

  dispose(){
    _roomPressed.close() ;
  }

}