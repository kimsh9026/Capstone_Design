import 'dart:async';

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';


class FriendProfilePage extends StatefulWidget {

  String uid ;

  FriendProfilePage(this.uid) ;

  @override
  _FriendProfilePageState createState() {
    return _FriendProfilePageState();
  }
}

class _FriendProfilePageState extends State<FriendProfilePage>{

  String _uid ;
  bool isFriend = false ;
  StreamSubscription<DocumentSnapshot> _subscription ;

  @override
  void initState() {
    super.initState();
    _uid = widget.uid ;
    _subscription = FirestoreProvider().getCurrentUserInfo().listen((snapshot){
      if(snapshot.data.containsKey('friend')){
        if(isFriend != snapshot.data['friend'].contains(_uid)){
          setState(() {
            isFriend = !isFriend ;
          });
        }
      }
      else{
        isFriend = false ;
      }
    }) ;
  }

  @override
  void dispose() {
    _subscription.cancel() ;
    super.dispose();
  }

  void addFriend(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: Text(
                '친구로 추가하시겠습니까?',
              ),
              actions: <Widget>[
                FlatButton(
                    child: const Text('추가', style: TextStyle(color: Colors.blue),),
                    onPressed: () { Navigator.pop(context, 'agree'); }
                )
              ]
          ) ;
        }
    )
        .then((value){
      if(value != null){
        FirestoreProvider().addFriend(_uid) ;
        Navigator.pop(context) ;
      }
    });
  }

  void eraseFriend(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: Text(
                '정말 삭제하시겠습니까?',
              ),
              actions: <Widget>[
                FlatButton(
                    child: const Text('삭제', style: TextStyle(color: Colors.blue),),
                    onPressed: () { Navigator.pop(context, 'agree'); }
                )
              ]
          ) ;
        }
    )
        .then((value){
      if(value != null){
        FirestoreProvider().eraseFriend(_uid) ;
        Navigator.pop(context) ;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
        stream: FirestoreProvider().getUserStream(_uid),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Color.fromRGBO(47, 146, 217, 0.9),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color:Color.fromRGBO(61, 174, 218, 1),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.white,
                  title: Text("프로필", textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
                  centerTitle: true,
                  elevation: 0.0,
                  actions: <Widget>[
                    isFriend ?
                    IconButton(
                      icon:Icon(
                        Icons.delete_forever,
                        color: Color.fromRGBO(47, 146, 217, 0.9),
                      ),
                      onPressed: (){
                        eraseFriend(context) ;
                      },
                    ) : IconButton(
                      icon:Icon(
                        Icons.person_add,
                        color: Color.fromRGBO(47, 146, 217, 0.9),
                      ),
                      onPressed: (){
                        addFriend(context) ;
                      },
                    )
                    ,
                  ],
                ),
                body: Column(
                    children: <Widget>[
                      Expanded(
                        //gradation이 적용된 배경..
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin:Alignment.topCenter,
                                  end:Alignment.bottomCenter,
                                  stops:[0.0, 0.18],
                                  colors: [
                                    Color.fromRGBO(61,174,218,1),
                                    Colors.white,
                                  ]
                              )
                          ),
                          //사용자 프로필
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      //사용자 사진
                                      Container(
                                        width:160,
                                        height:160,
                                        child: Stack(
                                            children:<Widget>[
                                              Container(
                                                width:160,
                                                height:160,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        fit:BoxFit.fill,
                                                        image: NetworkImage(
                                                          snapshot.data['photoUrl'],
                                                        )
                                                    )
                                                ),
                                              ),
                                              //사용자에게 메세지 보내기
                                              Container(
                                                alignment: Alignment.bottomRight,
                                                child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(61, 174, 218, 1),
                                                    ),
                                                    child: IconButton(
                                                        icon:Icon(Icons.message),
                                                        color: Colors.white,
                                                        onPressed: (){
                                                          List<dynamic> list = List<dynamic>() ;
                                                          list.add(context) ;
                                                          list.add(_uid) ;
                                                          BlocProvider.of(context).roomBloc.personalChat(list) ;
                                                        }
                                                    )
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      //사용자 이름
                                      Container(
                                          margin: EdgeInsets.only(top:10),
                                          child: Text(
                                            //사용자 이름.. DB에서 뽑아오기~
                                            snapshot.data['nickname'],
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 30),
                                          )
                                      ),

                                      //사용자 상태메세지
                                      Container(
                                          child: Text(
                                            snapshot.data['status'] == null ? "" : snapshot.data['status'],
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color:Colors.grey),//fontSize: 30),
                                          )
                                      ),

                                      //사용자 정보
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(15,5,0,0),
                                          child: Text(
                                            'User\'s Information',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color:Colors.grey),
                                          )
                                      ),
                                      //Stream Builder로 사용자 정보 받아와야해!!
                                      SizedBox(
                                        height:3,
                                      ),
                                      //나이, 성별, 거주지역, 언어, 이메일, 자기소개
                                      Column(
                                          children: <Widget>[
                                            Container(
                                              color: Color.fromRGBO(246, 246, 246, 1),
                                              margin: EdgeInsets.only(left:15, right:15),
                                              height:30,
                                              child : Row(
                                                  children:<Widget> [
                                                    Container(
                                                        width:80,
                                                        margin: EdgeInsets.only(left:15),
                                                        //color: Colors.black
                                                        alignment: Alignment.centerLeft,
                                                        child:Text("나이")
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child:Text(snapshot.data['age'] == null ? "" : snapshot.data['age'].toString()),
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:15, right:15),
                                              height:30,
                                              child : Row(
                                                  children:<Widget> [
                                                    Container(
                                                        width:80,
                                                        //color: Colors.black
                                                        margin: EdgeInsets.only(left:15),
                                                        alignment: Alignment.centerLeft,
                                                        child:Text("성별")
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child:Text(snapshot.data['gender'] == null ? "" : snapshot.data['gender']),
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:15, right:15),
                                              color: Color.fromRGBO(246, 246, 246, 1),
                                              height:30,
                                              child : Row(
                                                  children:<Widget> [
                                                    Container(
                                                        width:80,
                                                        //color: Colors.black
                                                        margin: EdgeInsets.only(left:15),
                                                        alignment: Alignment.centerLeft,
                                                        child:Text("언어")
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child:Text(snapshot.data['language'] == null ? "" : snapshot.data['language']),
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:15, right:15),
                                              height:30,
                                              child : Row(
                                                  children:<Widget> [
                                                    Container(
                                                        width:80,
                                                        //color: Colors.black
                                                        margin: EdgeInsets.only(left:15),
                                                        alignment: Alignment.centerLeft,
                                                        child:Text("연락처")
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child:Text(snapshot.data['email'] == null ? "" : snapshot.data['email']),
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:15, right:15),
                                              color: Color.fromRGBO(246, 246, 246, 1),
                                              height:30,
                                              child : Row(
                                                  children:<Widget> [
                                                    Container(
                                                        width:80,
                                                        //color: Colors.black
                                                        margin: EdgeInsets.only(left:15),
                                                        alignment: Alignment.centerLeft,
                                                        child:Text("자기소개")
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child:Text(snapshot.data['intro'] == null ? "" : snapshot.data['intro']),
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ]
                                      ),

                                      //여행 일정
                                      /*
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(15,5,0,0),
                              child: Text(
                                '\n\nTravel Schedule',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color:Colors.black),//fontSize: 30),
                              )
                            ),
                            */

                                      //Stream Builder로 여행 정보 받아와야해!!
                                    ]
                                )
                            ),
                          ),
                        ),
                      )
                    ]
                ),
            );
          }
          else{
            return Scaffold(
                appBar:AppBar(
                  title : Text(""),
                )
            );
          }
        }
    );
  }
}