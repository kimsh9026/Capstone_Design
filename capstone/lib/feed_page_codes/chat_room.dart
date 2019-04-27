

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget{
  //future error 뭐라는겨
  RoomInfo _roomInfo = RoomInfo();
  String _currentUserName = FireAuthProvider.user.displayName ;
  String _currentUserUID = FireAuthProvider.user.uid ;

  Widget _chatBody(BuildContext context, DocumentSnapshot document){
    return new Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
//              decoration: new BoxDecoration(
//                shape: BoxShape.circle,
//                color: Colors.yellow,
//                image: new DecorationImage(
//                  fit: BoxFit.cover,
//                  image: AssetImage('Images/sample.png'),
//                ),
//              ),
              child: new CircleAvatar(
                child: new Image.network("http://res.cloudinary.com/kennyy/image/upload/v1531317427/avatar_z1rc6f.png"),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_currentUserName, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(document['message']),
                )
              ],
            )
          ],
        )
    );

    //    return Text(document['message'].toString());
  }

  Widget _createChatRoomBody(context){
    return StreamBuilder(
        stream: BlocProvider.of(context).roomBloc.roomMessages,
        builder: (context, snapshot){
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            return Container(
              color: Colors.blueGrey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, int,
                              {
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                  top: 30.0,
                                  bottom: 30.0,
                                ),
                              }) {
                            return _chatBody(context, snapshot.data.documents[int]);
                          },
                        )
                    ),
                    new Divider(
                      color: Colors.black,
                      height: 3.0,
                    ),
                    new Container(decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                      child: TextField(),
                    ),
                  ],
                ),
              )
            ) ;
          }
        }
    ) ;
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of(context).roomBloc.getRoomSnapshot,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(45),
                  child: AppBar(
                    actions: <Widget>[
                      IconButton(icon: Icon(Icons.menu)),
                    ],
                    elevation: 0.1,
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    title: Text(
                      '',
                      style: Theme.of(context).textTheme.title,
                    ),
                    iconTheme: IconThemeData(
                      color: Color.fromRGBO(47, 146, 217, 0.9),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                body: Container()
            );
          }
          else{
            _roomInfo.setDocument(snapshot.data) ;
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(45),
                child: AppBar(
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.menu)),
                  ],
                  elevation: 0.1,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    _roomInfo.roomName,
                    style: Theme.of(context).textTheme.title,
                  ),
                  iconTheme: IconThemeData(
                    color: Color.fromRGBO(47, 146, 217, 0.9),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: _createChatRoomBody(context),
            );
          }

        }
    ) ;
  }

}

