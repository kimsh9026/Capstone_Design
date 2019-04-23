//import 'package:capstone/chat_room_codes/chat_room_info.dart';
import 'package:capstone/bloc_codes/BlocProvider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:flutter/material.dart';
//import 'profie_page.dart' ;
import 'package:capstone/feed_page_codes/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
/*
* 이미지 UI 그리는 부분 수정 필요
 */

class RoomCard extends StatefulWidget{

  final DocumentSnapshot document ;

  DocumentSnapshot get roomInfo => document ;

  RoomCard(BuildContext context, this.document) ;

  @override
  RoomCardState createState() => new RoomCardState();
}


class RoomCardState extends State<RoomCard> {
  RoomInfo _roomInfo = RoomInfo();

  void initState(){
    super.initState() ;
    _roomInfo.setDocument(widget.document) ;
  }

  Widget get roomImage {

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
/*
//    var placeholder = new Container(
//        width: 50.0,
//        height: 50.0,
//        decoration: new BoxDecoration(
//          shape: BoxShape.circle,
//          gradient: new LinearGradient(
//            begin: Alignment.topLeft,
//            end: Alignment.bottomRight,
//            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
//          ),
//        ),
//        alignment: Alignment.center,
//        child: new Text(
//          'Room',
//          textAlign: TextAlign.center,
//        )
//    );
//
//    var crossFade = new AnimatedCrossFade(
//      firstChild: placeholder,
//      secondChild: roomAvatar,
//      crossFadeState: 1 == 2
//          ? CrossFadeState.showFirst
//          : CrossFadeState.showSecond,
//      duration: new Duration(milliseconds: 1000),
//    );
//
//    return crossFade;
*/
    return roomImage ;
  }

  Widget _titleText(){
    return Text(
      '${widget.document['roomName']}',
      style: Theme.of(context).textTheme.headline,
    ) ;
  }

  Widget _dateNTimeRow(){
    DateTime date = widget.document['meetingDateTime'].toDate() ;
    return Row(
        children: <Widget>[
          new Icon(Icons.calendar_today, size: 12),
          new Text(' ${date.year}년 ${date.month}월 ${date.day}일',
              style: Theme.of(context).textTheme
                  .body1
          ),
          new Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
          ),
          new Icon(Icons.access_time, size: 12),
          new Text(
              '${date.hour}시 ${date.minute}분',
              style: Theme.of(context).textTheme.body1
          ),
        ]
    ) ;
  }

  Widget _meetingLocationRow(){
    return Row(
      children: <Widget>[
        new Icon(Icons.location_on, size: 12),
        new Text('${widget.document['meetingLocation']}',
            style: Theme.of(context).textTheme.body1
        ),
      ],
    ) ;
  }

  Widget _peopleCountRow(){
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

  Widget get roomCard {
    return new Container(
      //  tag: roomCard,
      width: 390,
      height: 125.0,
      child: new Card(
        elevation: 3,
        color: Colors.white,
        child: new Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 20.0,
          ),
          child: new Row(
              children: <Widget>[
                roomImage,
                new Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                  )),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _titleText(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                        ),
                        _dateNTimeRow(),
                        _meetingLocationRow(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 7,
                          ),
                        ),
                       _peopleCountRow(),
                      ],
                    )
                ),
              ]

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        print('here is room card : ${_roomInfo.roomCreatedTime}') ;
        BlocProvider.of(context).roomBloc.setEnterRoom(_roomInfo) ;
        BlocProvider.of(context).bottomBarBloc.setBottomBarPressed(3) ;
      },
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: new Container(
          height: 125.0,
          child: roomCard,
        ),
      ),
    );
  }



  showRoomDetailPage() {
//    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
//      return DetailPage(chatRoom);
//    }));

    return showDialog(
        context: context,
        builder: (BuildContext context){
          return DetailPage(roomCard) ;
        }
    );

  }







}