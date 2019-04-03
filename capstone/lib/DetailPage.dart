import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart';
import 'package:capstone/RoomCard.dart';
class DetailPage extends StatelessWidget {

  final Container roomCard ;

  DetailPage(this.roomCard) ;

  @override
  Widget build(BuildContext context) {

//    return roomCard ;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        roomCard,
//        Align(
//          alignment: Alignment.topRight,
//          child: RaisedButton.icon(
//              color: Theme.of(context).accentColor,
//              textColor: Colors.white,
//              onPressed: () => Navigator.pop(context),
//              icon: Icon(
//                Icons.close,
//                color: Colors.white,
//              ),
//              label: Text('Close')),
//        ),
      ],
    );

//
//    return Dialog(
//      child: roomCard,
//    );


//    return AlertDialog(
//      title: new Text("Alert Dialog title"),
//      content:roomCard,
//      actions: <Widget>[
//        // usually buttons at the bottom of the dialog
//        new FlatButton(
//          child: new Text("Close"),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ],
//    );




  }
}