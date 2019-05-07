

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
    int index = 1 ;
    _roomInfo.users.forEach((uid) async {
      var result = await FirestoreProvider().getUserSnapshot(uid);
      _usersUID.add(result.data['id']) ;
      _usersDisplayName.add(result.data['nickname']) ;
      print(_usersDisplayName.last) ;
      _usersImageURL.add(result.data['photoUrl']) ;
      if(_roomInfo.users.length == index){
        BlocProvider.of(context).roomBloc.setDidGetUserSnapshot(true) ;
      }
      index++ ;
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
                //new Text('Me'),
                new Card(
                  color: Colors.yellow,
                  margin: const EdgeInsets.only(left: 5, right:15),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left:15, right:15),
                    alignment: Alignment.center,
                    child: Text(document['message'], style:TextStyle(fontSize:20)),
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
                Container(
                  padding: EdgeInsets.only(left:10),
                  child: new Text(_usersDisplayName.elementAt(_usersUID.indexOf(document['uid'])), style: TextStyle(fontSize:15)),
                ),

                new Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 15, top:5),
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.fromLTRB(15,0,15,0),
                      alignment: Alignment.center,
                      child: Text(document['message'], style:TextStyle(fontSize:20)),
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

  Widget _messageBox(BuildContext context){
    return new Container(decoration: new BoxDecoration(
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
    ) ;
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
              color: Color.fromRGBO(61, 174, 218, 150),
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
                    _messageBox(context),
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
    print('1') ;
    return StreamBuilder(
        stream: BlocProvider.of(context).roomBloc.getRoomSnapshot,
        builder: (context, snapshot) {
          print('2') ;
          if(!snapshot.hasData){
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(45),
                  child: AppBar(
                    actions: <Widget>[
                      IconButton(icon: Icon(Icons.menu), color:Color.fromRGBO(47, 146, 217, 0.9)),
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
            print('3') ;
            print(snapshot.data['users'].length) ;
            print(_usersUID.length) ;
            if(snapshot.data['users'].length != _usersUID.length){
              print('4') ;
              BlocProvider.of(context).roomBloc.setDidGetUserSnapshot(false) ;
              _roomInfo.setDocument(snapshot.data) ;
              _getUsersInfo(context) ;
            }
            return StreamBuilder(
              stream: BlocProvider.of(context).roomBloc.didGetUserSnapshot,
              builder: (context, snapshot){
                print('5') ;
                if(!snapshot.hasData || !snapshot.data){
                  print('6') ;
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
                  print('7') ;
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

