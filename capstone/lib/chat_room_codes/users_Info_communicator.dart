
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:flutter/cupertino.dart';

class UsersInfoCommunicator {

  static RoomInfo roomInfo;
  RoomInfo _roomInfo ;
  BuildContext _context ;
  Map<String, String> _usersDisplayName = Map<String, String>() ;
  Map<String, String> _usersImageURL = Map<String, String>() ;
  final String _currentUserUID = FireAuthProvider.user.uid ;
  final String _currentUserDisplayName = FireAuthProvider.user.displayName ;

  UsersInfoCommunicator(BuildContext context){
    _roomInfo = roomInfo ;
    _context = context ;
    FirestoreProvider().getRoomSnapshot(_roomInfo).listen((data){
      _roomInfo.setDocument(data) ;
      _setUserInfo() ;
    }) ;
  }

  Future<void> _setUserInfo() {
    _usersDisplayName.clear() ;
    _usersImageURL.clear() ;
    int index = 1 ;
    _roomInfo.users.forEach((uid) async {
      var result = await FirestoreProvider().getUserSnapshot(uid);
      _usersDisplayName.putIfAbsent(uid, () => result.data['nickname']) ;
      _usersImageURL.putIfAbsent(uid, () => result.data['photoUrl']) ;
      if(_roomInfo.users.length == index){
        print('User Info collecting ended') ;
        BlocProvider.of(_context).roomBloc.setDidGetUserSnapshot(true) ;
      }
      index++ ;
    });
  }

  Map<String, String> get usersDisplayName => _usersDisplayName;

  set usersDisplayName(Map<String, String> value) {
    _usersDisplayName = value;
  }

  Map<String, String> get usersImageURL => _usersImageURL;

  String get currentUserUID => _currentUserUID;

}