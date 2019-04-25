import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatefulWidget{
  final DocumentSnapshot document ;

  DocumentSnapshot get roomInfo => document ;

  ChatRoomCard(BuildContext context, this.document) ;

  @override
  ChatRoomCardState createState() => new ChatRoomCardState();
}

class ChatRoomCardState extends State<ChatRoomCard> {
  RoomInfo _roomInfo = RoomInfo();

  void initState(){
    super.initState() ;
    _roomInfo.setDocument(widget.document) ;
  }

  Widget get _roomImage {

    var roomImage = new Hero(
      tag: widget.document,
      child: new Container(
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('Images/sample.png'),
          ),
        ),
      ),
    );

    return roomImage ;
  }

  Widget get _titleText{
    return Text(
      '${widget.document['roomName']}',
      style: Theme.of(context).textTheme.headline,
    ) ;
  }

  Widget get _peopleCountRow{
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Text('${widget.document['currentNumber']}/${widget.document['totalNumber']}'),
        Padding(
          padding: EdgeInsets.only(right: 20),
        ),
      ],
    ) ;
  }

  Widget get _roomCard {
    return Container(
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            _roomImage,
            new Padding(
              padding: const EdgeInsets.only(left : 20),
            ),
            _titleText,
            _peopleCountRow

          ],
        )
      )
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        BlocProvider.of(context).roomBloc.setRoomEntering(_roomInfo) ;
        BlocProvider.of(context).roomBloc.setIsRoomEntered(context) ;
      },
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: new Container(
          height: 125.0,
          child: _roomCard,
        ),
      ),
    );
  }

}