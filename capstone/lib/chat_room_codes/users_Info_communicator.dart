
import 'dart:async';

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UsersInfoCommunicator {

  static RoomInfo roomInfo;
  RoomInfo _roomInfo ;
  BuildContext _context ;
  Map<String, String> _usersDisplayName = Map<String, String>() ;
  Map<String, String> _usersImageURL = Map<String, String>() ;
  Map<String, String> _usersUID = Map<String, String>() ;

  final String _currentUserUID = FireAuthProvider.user.uid ;
  final String _currentUserDisplayName = FireAuthProvider.user.displayName ;
  StreamSubscription<DocumentSnapshot> _subscription ;

  UsersInfoCommunicator(BuildContext context){
    _roomInfo = roomInfo ;
    _context = context ;
    _subscription = FirestoreProvider().getRoomSnapshot(_roomInfo).listen((data){
      if(data.exists){
        _roomInfo.setDocument(data) ;
        _setUserInfo() ;
      }
    }) ;
  }

  void close(){
    _subscription.cancel() ;
  }

  Future<void> _setUserInfo() {
    _usersDisplayName.clear() ;
    _usersImageURL.clear() ;
    int index = 1 ;
    _roomInfo.users.forEach((uid) async {
      var result = await FirestoreProvider().getUserSnapshot(uid);
      _usersDisplayName.putIfAbsent(uid, () => result.data['nickname']) ;
      _usersImageURL.putIfAbsent(uid, () => result.data['photoUrl']) ;
      _usersUID.putIfAbsent(uid, () => uid) ;
      if(_roomInfo.users.length == index){
        BlocProvider.of(_context).roomBloc.setDidGetUserSnapshot(true) ;
      }
      index++ ;
    });
  }

  Map<String, String> get usersUID => _usersUID;

  set usersUID(Map<String, String> value) {
    _usersUID = value;
  }

  Map<String, String> get usersDisplayName => _usersDisplayName;

  set usersDisplayName(Map<String, String> value) {
    _usersDisplayName = value;
  }

  Map<String, String> get usersImageURL => _usersImageURL;

  String get currentUserUID => _currentUserUID;

}