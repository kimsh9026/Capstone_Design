import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/room_info.dart' ;

class ChatRoomPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("ChatRoomPage Build") ;
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoomPage Page'),
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
            'ChatRoomPage..',
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