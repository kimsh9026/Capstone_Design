import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart' ;

class DetailPage extends StatelessWidget {

  final ChatRoom room ;

  DetailPage(this.room) ;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: new Text("Alert Dialog title"),
      content: new Text("Alert Dialog body"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );


//    AlertDialog(
//      title: new Text(room.roomName),
//      content:
//    )
//      new Container(
//              width: 250.0,
//              height: 230.0,
//              decoration: new BoxDecoration(
//                shape: BoxShape.rectangle,
//                color: const Color(0xFFFFFF),
//              ),
//              margin: new EdgeInsets.only(left: 10.0, right: 10.0),
//              child: SizedBox(
//                height: 220.0,
//                child: Hero(
//                  tag: room,
//                  child: new Container(
//                    width: 150.0,
//                    height: 150.0,
//                    decoration: new BoxDecoration(
//                      shape: BoxShape.circle,
//                      image: new DecorationImage(
//                        fit: BoxFit.cover,
//                        image: AssetImage('Images/logo image.png'),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            );

    /*
      Scaffold(
      appBar: AppBar(
        title: Text('Detail Page!'),
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
*/



  }
}