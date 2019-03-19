import 'package:flutter/material.dart';
import 'package:capstone/fixing/ChatRoom.dart' ;
import 'package:capstone/fixing/BottomNavigation.dart' ;

class ProfilePage extends StatelessWidget {

  BottomNavigation botNavBar ;

  ProfilePage(this.botNavBar) ;

  @override
  Widget build(BuildContext context) {
    print("Profile Build") ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions:
        <Widget>[
          PopupMenuButton<BottomNavigationBarType>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: Text('Something1'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: Text('something2'),
              )
            ],
          )
        ],

      ),
      body: Center(
        child : Container(
          color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
          child: Center(child: Text(
            'Testing..',
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.white,
              decorationStyle: TextDecorationStyle.solid,
            ),
          )),
        ),
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}