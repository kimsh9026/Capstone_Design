import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/chat_room_codes/users_Info_communicator.dart';
import 'package:capstone/profile_edit_page.dart';
import 'package:capstone/USER.dart';

class ProfileEditPage extends StatefulWidget {

  @override
  _ProfileEditPageState createState() {
    return _ProfileEditPageState();
  }
}

class _ProfileEditPageState extends State<ProfileEditPage>{
  TextEditingController nameController;
  TextEditingController statusController;
  TextEditingController ageController;
  TextEditingController genderController;
  TextEditingController languageController;
  TextEditingController contactController;
  TextEditingController aboutMeController;

  void initialize(){
    nameController = TextEditingController();
    statusController = TextEditingController();
    ageController = TextEditingController();
  }

  Future<void> _update() async {
    await Firestore.instance.collection('userInfo')
        .document(FireAuthProvider.user.uid)
        .updateData({
      'nickname': nameController.text,
      'status': statusController.text,
      'age': int.parse(ageController.text),
      'gender': genderController.text,
      'language': languageController.text,
      'email': contactController.text,
      'intro': aboutMeController.text,
    });
  }

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
        stream: FirestoreProvider().getCurrentUserInfo(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            nameController = TextEditingController(text: snapshot.data['nickname']);
            statusController = TextEditingController(text: snapshot.data['status']);
            ageController = TextEditingController(text: snapshot.data['age'].toString());
            genderController = TextEditingController(text: snapshot.data['gender']);
            languageController = TextEditingController(text: snapshot.data['language']);
            contactController = TextEditingController(text: snapshot.data['email']);
            aboutMeController = TextEditingController(text: snapshot.data['intro']);

            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color:Color.fromRGBO(61, 174, 218, 1),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.white,
                  title: Text("프로필 수정", textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
                  centerTitle: true,
                  elevation: 0.0,
                  actions:
                  <Widget>[
                    IconButton(
                      icon: Icon(Icons.save_alt, color:Color.fromRGBO(61,174,218,1)),
                      onPressed: () async {
                        await _update();
                        print("Updated");
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
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
                                        //사용자 사진 추가
                                        /*
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
                                  */
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
                                                icon:Icon(Icons.add),
                                                color: Colors.white,
                                                  onPressed: ()=> print('hello!')
                                              )
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                  //사용자 이름
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child: TextField(
                                      decoration: InputDecoration.collapsed(
                                        border:InputBorder.none,
                                        //hintText: snapshot.data['nickname'],
                                        //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                      ),
                                      controller : nameController,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  //사용자 상태메세지
                                  Container(
                                    child: TextField(
                                      decoration: InputDecoration.collapsed(
                                          border:InputBorder.none,
                                          //hintText: snapshot.data['nickname'],
                                          //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                      ),
                                      controller : statusController,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color:Colors.grey),
                                    ),
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
                                                child: TextField(
                                                  decoration: InputDecoration.collapsed(
                                                    border:InputBorder.none,
                                                    //hintText: snapshot.data['age'].toString(),
                                                    //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                                  ),
                                                  controller : ageController,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
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
                                                          child:TextField(
                                                            decoration: InputDecoration.collapsed(
                                                              border:InputBorder.none,
                                                              //hintText: snapshot.data['age'].toString(),
                                                              //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                                            ),
                                                            controller : genderController,
                                                            textAlign: TextAlign.left,
                                                          ),
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
                                                          child:TextField(
                                                            decoration: InputDecoration.collapsed(
                                                              border:InputBorder.none,
                                                              //hintText: snapshot.data['age'].toString(),
                                                              //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                                            ),
                                                            controller : languageController,
                                                            textAlign: TextAlign.left,
                                                          ),
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
                                                          child:TextField(
                                                            decoration: InputDecoration.collapsed(
                                                              border:InputBorder.none,
                                                              //hintText: snapshot.data['age'].toString(),
                                                              //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                                            ),
                                                            controller : contactController,
                                                            textAlign: TextAlign.left,
                                                          ),
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
                                                          child:TextField(
                                                            decoration: InputDecoration.collapsed(
                                                              border:InputBorder.none,
                                                              //hintText: snapshot.data['age'].toString(),
                                                              //fillColor: Color.fromRGBO(246, 246, 256, 1)
                                                            ),
                                                            controller : aboutMeController,
                                                            textAlign: TextAlign.left,
                                                          ),
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
                )
              )
            );
          }
          else{
            print("ERROR!");
            return Scaffold(
                appBar:AppBar(
                  title : Text("Fail"),
                )
            );
          }
        }
    );
  }
}