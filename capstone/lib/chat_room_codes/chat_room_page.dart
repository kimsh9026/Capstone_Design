import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/room_info.dart' ;

class ChatRoomPage extends StatelessWidget {


  Widget _createChatRoomList(context) {
    print('here is chat room, and create chat room page now') ;
    return StreamBuilder(
        stream: BlocProvider.of(context).roomBloc.isRoomEntered,
        builder: (context, isEnterSnapshot){
          if(!isEnterSnapshot.hasData || isEnterSnapshot.data == false){
            print(isEnterSnapshot.data) ;
            print('here is chat room, and no data from isRoomEntered stream') ;
            return StreamBuilder(
                stream: BlocProvider.of(context).roomBloc.roomList,
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
                      return RoomCard(context, snapshot.data.documents[int]);
                    },
                  );
                }
            );
          }
          else
            print('here is chat room page, and message builder!') ;
            return StreamBuilder(
              stream: BlocProvider.of(context).roomBloc.roomMessages,
              builder: (context, messageSnapshot){
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  itemCount: messageSnapshot.data.documents.length,
                  itemBuilder: (context, int,
                      {
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          bottom: 30.0,
                        ),
                      }) {
                    print('here is inside of chatListBuilder ${messageSnapshot.data.documents[int]['message']}') ;
                    return _chatText(context, messageSnapshot.data.documents[int]) ;
                  },
                );
              }
            ) ;
        }
    ) ;
  }

  Widget _chatText(BuildContext context, DocumentSnapshot document){
    return Text(document['message'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(215, 238, 247, 0.9),
      appBar: AppBar(
          toolbarOpacity: 1,
          elevation: 0.1,
          bottomOpacity: 1,
          title: Text(
            '참여 채팅방',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            // might need profile check or something actions...
          ]
      ),
      body: Column(
        children: <Widget>[
          new Divider(color: Colors.black45, indent: 0.0, height: 0,),
          Expanded(
            child: new Center(
              child: _createChatRoomList(context),
            ),
          ),
        ],
      ),
    );
  }
}