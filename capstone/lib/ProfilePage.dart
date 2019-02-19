import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart' ;

class Profile extends StatelessWidget {

  final ChatRoom room ;

  Profile(this.room) ;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page!'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 0.9),
      ),
      backgroundColor: Colors.white70,
      body: Container(
        child: Center(
         child: Hero(
           tag: room,
           child: new Container(
             width: 150.0,
             height: 150.0,
             decoration: new BoxDecoration(
               shape: BoxShape.circle,
               image: new DecorationImage(
                 fit: BoxFit.cover,
                 image: AssetImage('Images/logo image.png'),
               ),
             ),
           ),
         ),
        ),
      ),
    );




  }
}