

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget{
  Future<DocumentSnapshot> _document;
  RoomInfo _roomInfo = RoomInfo();
  ChatRoom(this._document) ;

  Widget _chatText(BuildContext context, DocumentSnapshot document){
    return Text(document['message'].toString());
  }

  Widget _createChatRoomBody(context){
    return StreamBuilder(
        stream: BlocProvider.of(context).roomBloc.roomMessages,
        builder: (context, snapshot){
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            return ListView.builder(
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
                return _chatText(context, snapshot.data.documents[int]);
              },
            );
          }

        }
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _document,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
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
              body: snapshot.connectionState == ConnectionState.waiting ? CircularProgressIndicator() :
              _createChatRoomBody(context),
            );
          }

        }
    ) ;
  }

}

