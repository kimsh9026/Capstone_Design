import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart' ;
import 'package:capstone/RoomCard.dart' ;


class ListBlock extends StatelessWidget {
  final List<ChatRoom> chatRooms;

  ListBlock(this.chatRooms);

  ListView _buildList(context) {
    return new ListView.builder(
      itemCount: chatRooms.length,
      itemBuilder: (context, int) {
        return new RoomCard(chatRooms[int]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}