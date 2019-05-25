

import 'dart:async';

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FriendInfoCommunicator {

  List<String> friendsUID ;
  Map<String, String> friendsDisplayName ;
  Map<String, String> friendsImageURL ;
  Map<String, String> friendsStatus ;
  StreamSubscription<DocumentSnapshot> _subscription ;
  BuildContext context ;
  FriendInfoCommunicator(this.context){
    friendsUID = List<String>() ;
    friendsDisplayName = Map<String, String>()  ;
    friendsImageURL = Map<String, String>()  ;
    friendsStatus = Map<String, String>()  ;
    _subscription = FirestoreProvider().getCurrentUserInfo().listen((data){
      if(data.exists){
        friendsUID = List.from(data.data['friend']) ;
        getFriendsInfo(context) ;
      }
    }) ;
  }

  void close(){
    _subscription.cancel() ;
  }

  Future<void> getFriendsInfo(BuildContext context){
    friendsDisplayName.clear() ;
    friendsImageURL.clear() ;
    friendsStatus.clear() ;
    int index = 1 ;
    friendsUID.forEach((uid) async{
      var result = await FirestoreProvider().getUserSnapshot(uid);
      if(result.data != null){
        friendsDisplayName.putIfAbsent(uid, () => result.data['nickname']) ;
        friendsImageURL.putIfAbsent(uid, () => result.data['photoUrl']) ;
        friendsStatus.putIfAbsent(uid, () => result.data['status']) ;
      }
      if(friendsUID.length == index){
        BlocProvider.of(context).roomBloc.setDidGetFriendsSnapshot(true) ;
      }
      index++ ;
    }) ;
  }
}