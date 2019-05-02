

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget{
  //future error 뭐라는겨
  RoomInfo _roomInfo = RoomInfo();
  List<String> _usersDisplayName = List<String>() ;
  List<String> _usersUID = List<String>() ;
  List<String> _usersImageURL = List<String>() ;
  String _currentUserName = FireAuthProvider.user.displayName ;
  String _currentUserUID = FireAuthProvider.user.uid ;
  TextEditingController _textEditingController = TextEditingController() ;

  ChatRoom() {

  }

  Future<void> _getUsersInfo(BuildContext context) async {
    BlocProvider.of(context).roomBloc.setDidGetUserSnapshot(false) ;
    _roomInfo.users.forEach((uid) async {
      var result = await FirestoreProvider().getUserSnapshot(uid);
      print(result.data['photoUrl']) ;
      _usersUID.add(result.data['id']) ;
      _usersDisplayName.add(result.data['nickname']) ;
      _usersImageURL.add(result.data['photoUrl']) ;
    });
  }

  Widget _chatBody(BuildContext context, DocumentSnapshot document){
   return document['uid'] == _currentUserUID ? _myMessage(document)
    : _othersMessage(document) ;
  }

  Widget _myMessage(DocumentSnapshot document){
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text('Me'),
                new Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(document['message']),
                  )
                )
              ],
            ),
//            _usersImageURL.length == 0 ? Container(color: Colors.white30) :
//            CircleAvatar(
//                child: Image.network(_usersImageURL.elementAt(_roomInfo.users.indexOf(_currentUserUID)))
//            ),
          ],
        )
    );
  }

  Widget _othersMessage(DocumentSnapshot document){
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
//            _usersImageURL.length == 0 ? Container(color: Colors.white30) :
//            CircleAvatar(
//                child: Image.network(_usersImageURL.elementAt(_roomInfo.users.indexOf(_currentUserUID)))
//            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_usersDisplayName.elementAt(_usersUID.indexOf(document['uid']))),
                new Card(
                    color: Colors.white70,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(document['message']),
                    )
                )
              ],
            ),
          ],
        )
    );
  }

  void _sendMessage(BuildContext context, String msg){
    BlocProvider.of(context).roomBloc.sendMessage(_roomInfo, msg) ;
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
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: _textEditingController,
//                              onChanged: (str) => _textEditingController.text = str,
                              decoration: InputDecoration(
                                hintText: '메세지를 입력해주세요',
                              ),
                            ) ,
                          ),
                          Expanded(
                            flex: 1,
                            child:
                            IconButton(icon: Icon(Icons.send), onPressed: () {
                              if(_textEditingController.text.trim() != ''){
                                _sendMessage(context, _textEditingController.text) ;
                                _textEditingController.clear() ;
                              }
                            })
                          )
                        ],
                      )
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
        builder: (context, snapshot) {
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
            print('in the else') ;
            _roomInfo.setDocument(snapshot.data) ;
            _getUsersInfo(context)
                .whenComplete(() {
              BlocProvider.of(context).roomBloc.setDidGetUserSnapshot(true) ;
            }) ;
            return StreamBuilder(
              stream: BlocProvider.of(context).roomBloc.didGetUserSnapshot,
              builder: (context, snapshot){
                if(!snapshot.hasData || !snapshot.data){
                  print('no data') ;
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
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                else{
                  print('data: ${snapshot.data}') ;
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
            );
          }
        }
    ) ;
  }

}

