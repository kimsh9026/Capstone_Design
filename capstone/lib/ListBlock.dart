import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart';
import 'package:capstone/RoomCard.dart';
import 'package:capstone/BlocProvider.dart' ;
//import 'package:capstone/test/DetailPage.dart' ;

class ListBlock extends StatelessWidget {

  ListBlock();

  Widget _buildList(context) {
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.roomInfo,
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
            print('has Data!') ;
            return new RoomCard(context, snapshot.data.documents[int]);
          },
        );
      }
    );
  }

  Widget detailRoomView(int number) {
    //   return DetailPage(chatRooms[number], new RoomCard(chatRooms[number]).) ;
  }

  Widget createNewRoom(){
    return new Container(
      //  tag: roomCard,
      width: 500,
      height: 130.0,
      child: new Card(
        color: Colors.white,
        child: new Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 15.0,
          ),
          child: new Row(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Text('Name',
                      style: TextStyle(
                          fontSize: 18.0,
                          height: 1.3
                      ),
                    ),
                    new Text('Date', //String 안에서 변수를 사용할 때는 이런식으로 써요
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                    new Row(
                      children: <Widget>[
                        new Icon(
                          Icons.people,
                        ),
                        new Text('Number of People')
                      ],
                    )
                  ],
                ),
              ]

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}