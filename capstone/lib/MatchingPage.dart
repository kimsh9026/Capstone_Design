import 'package:flutter/material.dart';
//import 'package:capstone/test/ChatRoom.dart' ;
import 'package:capstone/BottomNavigation.dart';

class MatchingPage extends StatelessWidget {

  BottomNavigation botNavBar ;

  MatchingPage(this.botNavBar) ;

  @override
  Widget build(BuildContext context) {
    print("MatchingPage Build") ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Page'),
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
            'Matching..',
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.white,
              decorationStyle: TextDecorationStyle.solid,
            ),
          )),
        ),
      ),
//      bottomNavigationBar: botNavBar,
    );



  }
}