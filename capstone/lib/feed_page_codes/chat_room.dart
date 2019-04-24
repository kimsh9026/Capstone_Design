

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget{
  final RoomInfo _roomInfo ;

  ChatRoom(this._roomInfo) ;

  Widget _createChatRoomBody(context){
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.roomMessages,
      builder: (context, snapshot){
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator());
          } else {

          }

      }
    ) ;
  }

  @override
  Widget build(BuildContext context) {
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

