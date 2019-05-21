import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/chat_room_codes/users_Info_communicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget{

  RoomInfo _roomInfo ;
  TextEditingController _textEditingController = TextEditingController() ;

  ChatRoom(RoomInfo roomInfo){
    _roomInfo = roomInfo ;
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

  Widget _chatRoomBody(BuildContext context){
    return Container(
        color: Color.fromRGBO(61, 174, 218, 200),
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ChatBody(_roomInfo,context),
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

  @override
  Widget build(BuildContext context){
    print('build chat room') ;
//    _userInfoCommunicator.context = context ;
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.getRoomSnapshot,
      builder: (context, snapshot){
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
                snapshot.hasData ? snapshot.data['roomName']
                : _roomInfo.roomName,
                style: Theme.of(context).textTheme.title,
              ),
              iconTheme: IconThemeData(
                color: Color.fromRGBO(47, 146, 217, 0.9),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: _chatRoomBody(context),
        );
      },
    ) ;


  }

}

class ChatBody extends StatefulWidget {

  RoomInfo _roomInfo ;
  BuildContext _context ;

  ChatBody(this._roomInfo,this._context) ;

  @override
  _ChatBodyState createState() => _ChatBodyState() ;

}

class _ChatBodyState extends State<ChatBody> {


  UsersInfoCommunicator _userInfoCommunicator ;

  @override
  void initState() {
    super.initState() ;
    _userInfoCommunicator = UsersInfoCommunicator(widget._context) ;
  }


  Widget _othersMessage(DocumentSnapshot document){
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _userInfoCommunicator.usersImageURL.length == 0 ? Container(color: Colors.white30) :
            CircleAvatar(
                child: Image.network(_userInfoCommunicator.usersImageURL[document['uid']])
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left:10),
                    child: new Text(_userInfoCommunicator.usersDisplayName[document['uid']], style: TextStyle(fontSize:13)),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 30,
                    ),
                    child: new Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 10, top:5, right: 10),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10,6,6,6),
                          child: Text(
                            document['message'],
                            style:TextStyle(fontSize:15),
                            softWrap: true,
                            maxLines: 10,
                          ),)
                    ),
                  )

                ],
              ),
            )
          ],
        )
    );
  }

  Widget _myMessage(DocumentSnapshot document){
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
                child:
                Container(
                  constraints: BoxConstraints(
                    minHeight: 30,
                  ),
                  child: Card(
                      color: Colors.yellow,
                      margin: const EdgeInsets.only(left: 10, right:10),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10,6,6,6),
                      child: Text(
                        document['message'],
                        style:TextStyle(fontSize:15),
                        softWrap: true,
                        maxLines: 10,
                      ),)
                  ),
                )
            ),
            _userInfoCommunicator.usersImageURL.length == 0 ? Container(color: Colors.white30) :
            CircleAvatar(
                child: Image.network(_userInfoCommunicator.usersImageURL[document['uid']])
            ),
          ],
        )
    );
  }

  Widget _chatMessage(BuildContext context, DocumentSnapshot document){
    return document['uid'] == _userInfoCommunicator.currentUserUID ? _myMessage(document)
        : _othersMessage(document) ;
  }


  @override
  Widget build(BuildContext context) {
    print('chat body buid') ;
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.didGetUserSnapshot,
      builder: (context, snapshot){
        if(!snapshot.hasData || !snapshot.data){
          return Center(
              child: CircularProgressIndicator());
        }
        else{
          return StreamBuilder(
              stream: BlocProvider.of(context).roomBloc.roomMessages,
              builder: (context, snapshot){
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator());
                } else {
                  return Container(
                      color: Color.fromRGBO(61, 174, 218, 200),
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
                              return _chatMessage(context, snapshot.data.documents[int]);
                            },
                          )
                  ) ;
                }
              }
          );
        }
      },
    );
  }

}