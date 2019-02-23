import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart' ;
import 'package:capstone/ListBlock.dart' ;

void main() => runApp(FeedPage()) ;

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabuddy_FeedPage',
      theme: new ThemeData(brightness: Brightness.light),
      home: ListUp(),
    );
  }
}

class ListUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ListUpState() ;
}


class ListUpState extends State<ListUp> {

  ListBlock roomList = new ListBlock(<ChatRoom>[]
    ..add (new ChatRoom('Title', '2월 13일', '15:00'))
    ..add (new ChatRoom('같이 죽도시장 가실 분', '2월 12일', '15:00'))
    ..add (new ChatRoom('호미곶 갈사람', '2월 16일', '12:00'))
    ..add (new ChatRoom('포항호텔 파티 모집', '2월 19일', '21:00'))
    ..add (new ChatRoom('커몬~', '2월 13일', '15:00'))
  );

  Widget searchingBlock(){
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        border: InputBorder.none,
        hintText: 'Search',
        suffixIcon: Icon(Icons.search),
        fillColor: Colors.black,
      ),
    );
  }


  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 218, 218, 0.9),
      appBar: AppBar(
        toolbarOpacity: 1,
        elevation: 1,
        bottomOpacity: 1,
        title: Text(
          '동행 모집',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white70,
      ),
      body: Column(
        children: <Widget>[
          searchingBlock(),
          new Divider(color: Colors.black45, indent: 0.0, height: 0,),
          Expanded(
            child : new Center(
              child: roomList,
//              new ListBlock(<ChatRoom>[]
//          ..add (new ChatRoom('Title', '2월 13일', '15:00'))
//          ..add (new ChatRoom('같이 죽도시장 가실 분', '2월 12일', '15:00'))
//          ..add (new ChatRoom('호미곶 갈사람', '2월 16일', '12:00'))
//          ..add (new ChatRoom('포항호텔 파티 모집', '2월 19일', '21:00'))
//          ..add (new ChatRoom('커몬~', '2월 13일', '15:00'))
//        ),
            ),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: roomList.createNewRoom,
//        tooltip: 'create',
//        child: Icon(Icons.add_comment),
//      ),
//      new Center(
//        child:  new ListBlock(<ChatRooms>[]
//          ..add (new ChatRooms('Title', '2월 13일', '15:00'))
//          ..add (new ChatRooms('같이 죽도시장 가실 분', '2월 12일', '15:00'))
//          ..add (new ChatRooms('호미곶 갈사람', '2월 16일', '12:00'))
//          ..add (new ChatRooms('포항호텔 파티 모집', '2월 19일', '21:00'))
//          ..add (new ChatRooms('커몬~', '2월 13일', '15:00'))
//        ),
//      ),


//      Column(
//        children: <Widget>[
//          searchingBlock(),
//        ],

    );
  }

}