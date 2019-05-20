import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Friends', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
        centerTitle: true,
      )
    );
  }
}