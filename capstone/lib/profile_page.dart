import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/chat_room_codes/users_Info_communicator.dart';

/*
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{
  UsersInfoCommunicator _userInfoCommunicator ;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_userInfoCommunicator.usersDisplayName[document['uid']], style: TextStyle(fontSize:13)),
      )
    );
    
    /*return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
        centerTitle: true,
      ),
    );
    */
  }
}
*/

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Profile Build") ;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color:Color.fromRGBO(61, 174, 218, 1),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text('Profile', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
        centerTitle: true,
        elevation: 0.0,
        actions:
        <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color:Color.fromRGBO(61,174,218,1)),
          )
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
                                color: Colors.grey,
                              )
                            ),
                            //사용자 사진 추가
                            Container(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(61, 174, 218, 1),
                                  ),
                                  child: IconButton(
                                    icon:Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: ()=> print('hello!'),
                                  )
                                )
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
                                      onPressed: ()=> print('hello!'),
                                    )
                                )
                            ),

                          ]
                        ),
                      ),
                      //사용자 이름
                      Container(
                        margin: EdgeInsets.only(top:10),
                        child: Text(
                          //사용자 이름.. DB에서 뽑아오기~
                          'User',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 30),
                        )
                      ),

                      //사용자 상태메세지
                      Container(
                          child: Text(
                            'I think I\'m in hell',
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
                            style: TextStyle(color:Colors.black),//fontSize: 30),
                          )
                      ),
                      //Stream Builder로 사용자 정보 받아와야해!!

                      //여행 일정
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(15,5,0,0),
                          child: Text(
                            'Travel Schedule',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color:Colors.black),//fontSize: 30),
                          )
                      ),
                      //Stream Builder로 여행 정보 받아와야해!!


                    ]
                  )
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}
