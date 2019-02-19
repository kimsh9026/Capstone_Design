import 'ChatRoom.dart' ;
import 'package:flutter/material.dart';
import 'ProfilePage.dart' ;

class RoomCard extends StatefulWidget{
  final ChatRoom chatroom ;

  RoomCard(this.chatroom) ;

  @override
  RoomCardState createState() => new RoomCardState(chatroom);
}

class RoomCardState extends State<RoomCard> {

  ChatRoom chatRoom ;
  RoomCardState(this.chatRoom) ;

  void initState(){
    super.initState() ;
  }

  Widget get roomImage {
    var roomAvatar = new Hero(
      tag: chatRoom,
      child: new Container(
        width: 70.0,
        height: 70.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('Images/logo image.png'),
          ),
        ),
      ),
    );

    var placeholder = new Container(
        width: 50.0,
        height: 50.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: new Text(
          'Room',
          textAlign: TextAlign.center,
        )
    );

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: roomAvatar,
      crossFadeState: 1 == 2
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  Widget get roomCard {
    return new Positioned(
      child: new Container(
        width: 350,
        height: 115.0,
        child: new Card(
          color: Colors.white,
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 64.0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(widget.chatroom.roomName,
                  style: TextStyle(
                      fontSize: 18.0,
                      height: 1.3
                  ),
                ),
                new Text('${widget.chatroom.date} ${widget.chatroom.time}', //String 안에서 변수를 사용할 때는 이런식으로 써요
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.people,
                    ),
                    new Text(': ${widget.chatroom.currentPeopleNumbers} / ${widget.chatroom.fullPeopleNumbers}')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => showRoomDetailPage(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
        child: new Container(
          height: 115.0,
          child: new Stack(
            children: <Widget>[
              roomCard,
              new Positioned(top: 15.5, child: roomImage),
            ],
          ),
        ),
      ),
    );
  }

  showRoomDetailPage() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return  Profile(chatRoom);
    }));
  }

}