import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/chat_room_codes/profile_drawer.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/friend_info_communicator.dart';
import 'package:capstone/friend_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:capstone/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListPage extends StatefulWidget {

  @override
  FriendListPageState createState() => FriendListPageState() ;
}

class FriendListPageState extends State<FriendListPage>{

  ProfilePage profilePage = new ProfilePage() ;
  FriendInfoCommunicator _communicator ;
  @override
  void initState() {
    super.initState();
    _communicator = FriendInfoCommunicator(context) ;
  }

  @override
  void dispose() {
    _communicator.close() ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
//    _communicator.getFriendsInfo(context) ;
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.didGetFriendsSnapshot,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Scaffold(
              appBar:AppBar(
                backgroundColor: Colors.white,
                title: Text('프로필', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
                centerTitle: true,
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(47, 146, 217, 0.9),
                ),
              ),
              endDrawer: ProfileDrawer(context),
              body: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: _myTile(context),
                      ),
                      Divider(
                        height: 22,
                        color: Colors.grey,
                      ),
                    ],
                  )
              )
          );
        }
        else if(!snapshot.data){
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text('프로필', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
                centerTitle: true,
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(47, 146, 217, 0.9),
                ),
              ),
              endDrawer: ProfileDrawer(context),
              body: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: _myTile(context),
                      ),
                      Divider(
                        height: 22,
                        color: Colors.grey,
                      ),
                      Text('친구'),
                      Expanded(
                          flex: 8,
                          child: Center(
                            child: Text(
                                '동행할 친구를 찾아보세요!'
                            ),
                          )
                      ),
                    ],
                  )
              )
          ) ;
        }
        else{
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text('프로필', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
              centerTitle: true,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Color.fromRGBO(47, 146, 217, 0.9),
              ),
            ),
            body: _friendBody(context),
            endDrawer: ProfileDrawer(context),
          );
        }
      },
    ) ;
  }

  Widget _friendBody(BuildContext context){
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Expanded(
              flex: 1,
              child: _myTile(context),
            ),
            Divider(
              height: 22,
              color: Colors.grey,
            ),
            Text('친구'),
            Expanded(
              flex: 8,
              child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              itemCount: _communicator.friendsUID.length,
              itemBuilder: (context, int,
                  {
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      bottom: 30.0,
                    ),
                  }) {
                return _friendTile(context, _communicator.friendsUID[int]);
              },
            )
            ),
          ],
        )
    ) ;
  }

  Widget _myTile(BuildContext context){
    return StreamBuilder(
      stream: FirestoreProvider().getCurrentUserInfo(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return ListTile(
              leading: CircleAvatar(
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      )
                  )
              ),
              title: Text(" "),
              trailing: Icon(Icons.people),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              }
          ) ;
        }
        else{
          return ListTile(
              leading: CircleAvatar(
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Image.network(snapshot.data['photoUrl']),
                  )
              ),
              title: Text(snapshot.data['nickname']),
              subtitle: snapshot.data['status'] != null ? Text(snapshot.data['status']) : Text(''),
//              trailing: Icon(Icons.people),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              }
          ) ;
        }
      }
    ) ;
  }

  Widget _friendTile(BuildContext context, String uid){
    return ListTile(
        leading: CircleAvatar(
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              child: Image.network(_communicator.friendsImageURL[uid]),
            )
        ),
        title: Text(_communicator.friendsDisplayName[uid]),
        subtitle: _communicator.friendsStatus[uid]!= null ? Text(_communicator.friendsStatus[uid]) : Text(''),
        trailing: Icon(Icons.people),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendProfilePage(uid)),
          );
        }
    ) ;
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