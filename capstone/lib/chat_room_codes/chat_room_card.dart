import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatefulWidget{
  final DocumentSnapshot document ;

//  DocumentSnapshot get getDocument => document ;

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

    String buddy = 'Images/category_ui/buddy_active.png' ;
    String meal = 'Images/category_ui/meal_active.png' ;
    String stay = 'Images/category_ui/stay_active.png' ;
    String tran = 'Images/category_ui/tran_active.png' ;

    return Container(
      width: 60.0,
      height: 60.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
              _roomInfo.roomPurpose == '동행' ? buddy :
              (_roomInfo.roomPurpose == '식사' ? meal :
              (_roomInfo.roomPurpose == '숙소' ? stay : tran))
          ),
        ),
      ),
    ) ;
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
      decoration: BoxDecoration(
        color: Colors.white,
//        border: Border.all(color: Colors.blueGrey, width:0.06)
      ),
      height: 70,
      child: Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left : 10),
          ),
          _roomImage,
          new Padding(
            padding: const EdgeInsets.only(left : 20),
          ),
          Expanded(
            flex: 5,
            child: _titleText
          ),
          Expanded(
              flex: 1,
              child: _peopleCountRow,
          ),
        ],
      )
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    _roomInfo.setDocument(widget.document) ;
    return new InkWell(
      onTap: () {
        BlocProvider.of(context).roomBloc.setRoomEntering(_roomInfo) ;
        BlocProvider.of(context).roomBloc.setIsRoomEntered(context) ;
      },
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child:  _roomCard,
      ),
    );
  }

}