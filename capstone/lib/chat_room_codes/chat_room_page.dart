import 'package:capstone/bloc_codes/BlocProvider.dart';
import 'package:capstone/feed_page_codes/room_card.dart';
import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/room_info.dart' ;

class ChatRoomPage extends StatelessWidget {


  Widget _createChatRoomList(context) {

    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.roomMessages,
        builder: (context, messageSnapshot){
          if(!messageSnapshot.hasData){
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
                      return new RoomCard(context, snapshot.data.documents[int]);
                    },
                  );
                }
            );
          }
          else
            print('room Message item builder2') ;

//            return StreamBuilder(
//              stream: BlocProvider.of(context).roomBloc.roomMessages,
//              builder: (context, snapshot) {
//                print('here is chat room: ${snapshot.hasData ? snapshot.data : null}') ;
//                if(!snapshot.hasData) return const Text('Loading..') ;
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
                    print('room Message item builder') ;
                    print(messageSnapshot.data.documents[int]['message']) ;
                    return Text(messageSnapshot.data.documents[int]['message'].toString());
                  },
                );
              }
            ) ;

//
//        }
//    ) ;


//
  }


  @override
  Widget build(BuildContext context) {
    print("ChatRoomPage Build") ;

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

//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          Navigator.of(context).push(MaterialPageRoute(builder: (context){
//            return roomList.createNewRoom(context) ;
//          })) ;
//        },
//        tooltip: 'create room',
//        child: Icon(Icons.add_comment),
//      ),
    );
  }
}