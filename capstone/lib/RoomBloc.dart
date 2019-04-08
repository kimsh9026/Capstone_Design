import 'dart:async';
import 'package:flutter/material.dart';
import 'RoomInfo.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/FirestoreProvider.dart' ;
class RoomBloc extends Object{

  BuildContext _context ;
  final _roomPressed = StreamController<int>.broadcast() ;
  final _initRooms = StreamController<bool>.broadcast() ;
  final _scrollRooms = StreamController<bool>.broadcast() ;
  final _addedRoom = StreamController<RoomInfo>.broadcast() ;
  final _roomList = FirestoreProvider().roomList;

  Stream<int> get roomPressed => _roomPressed.stream ;
  Stream<bool> get initRooms => _initRooms.stream ;
  Stream<bool> get scrollRooms => _scrollRooms.stream ;
  Stream<RoomInfo> get addedRoom => _addedRoom.stream ;
  Stream<QuerySnapshot> get roomList => _roomList ;



  Function(int) get setRoomPressed => _roomPressed.sink.add ;
  Function(bool) get setInitRooms => _initRooms.sink.add ;
  Function(bool) get setScrollRooms => _scrollRooms.sink.add ;
  Function(RoomInfo) get registerRoom => FirestoreProvider().registerRoom;
  //해결필요
//  Function(Map<String,dynamic>) get setRoomInfo =>  Firestore.instance.collection('roomInfo').add ;

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

//    addRoom.listen((roomInfo){
//      print('string added') ;
//      Firestore.instance.collection('roomInfo').document().setData({
//        'name' : roomInfo.roomName,
//        'dateNtime' : roomInfo.dateNTime,
//        'currentnumber' : 2,
////        'currentnumber' : roomInfo.currentNumber,
//        'totalnumber' : 4,
////        'totalnumber' : roomInfo.totalNumber,
//      }) ;
//    },onError:  (error){
//      print("error occured");
//      Scaffold.of(_context).showSnackBar(new SnackBar(
//        content: new Text("Error!"),
//      ));
//    }
//    );

  }

  dispose(){
    _roomPressed.close() ;
    _initRooms.close() ;
    _scrollRooms.close() ;
    _addedRoom.close() ;
  }

}