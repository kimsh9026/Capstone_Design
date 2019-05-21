import 'package:flutter/material.dart';
import 'package:capstone/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListPage extends StatelessWidget{
  ProfilePage profilePage = new ProfilePage() ;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Friends', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
        centerTitle: true,
        elevation: 0.0,

      ),
      body: Container(
        color: Colors.white,
        child: ListView(
            children: <Widget> [
              //MyProfile
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    )
                  )
                ),
                title: Text("Example Name"),
                subtitle: Text("Example status"),
                trailing: Icon(Icons.people),
                onTap: (){
                  print("On Pressed.. correct!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              ),
              Container(
                margin:EdgeInsets.fromLTRB(5, 0, 5, 0),
                child:Text(
                  "현재 동행",
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        )
                    )
                ),
                title: Text("Example Name"),
                subtitle: Text("Example status"),
                trailing: Icon(Icons.people),
                onTap: () {
                  print("On Pressed.. correct!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              ),
              Container(
                margin:EdgeInsets.fromLTRB(5, 0, 5, 0),
                child:Text(
                  "친구",
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        )
                    )
                ),
                title: Text("Example Name"),
                subtitle: Text("Example status"),
                trailing: Icon(Icons.people),
                onTap: () {
                  print("On Pressed.. correct!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              ),
            ]
        )
      )
    );
  }
}


/*
class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState(){
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Friends', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
        centerTitle: true,
      ),
    );
  }
}
*/