import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/chat_room_codes/chat_room_card.dart';
import 'package:capstone/feed_page_codes/feed_room_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/room_info.dart' ;

class MyChatRoomPage extends StatelessWidget {

  Widget _createChatRoomList(context){
    return StreamBuilder(
        stream: BlocProvider.of(context).roomBloc.chatRoomList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading..') ;
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
              return ChatRoomCard(context, snapshot.data.documents[int]);
            },
          );
        }
    );
  }

  Widget _chatText(BuildContext context, DocumentSnapshot document){
    return Text(document['message'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarOpacity: 1,
          elevation: 0.1,
          bottomOpacity: 1,
          title: Text(
            '채팅',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            // might need profile check or something actions...
          ]
      ),
      body: _createChatRoomList(context)
    );
  }
}