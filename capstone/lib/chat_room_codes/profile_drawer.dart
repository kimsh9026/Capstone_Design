import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/chat_room_codes/users_Info_communicator.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class ProfileDrawer extends StatefulWidget{
  BuildContext _context ;
  ProfileDrawer(this._context) ;

  @override
  State<StatefulWidget> createState() {
    return ProfileDrawerState();
  }
}

class ProfileDrawerState extends State<ProfileDrawer> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreProvider().getCurrentUserInfo(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Drawer(
            child: Container(),
          ) ;
        }
        else{
          final header = UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Color.fromRGBO(47, 146, 217, 0.9)
            ),
            accountName: Text(snapshot.data['nickname'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17),),
            accountEmail: Text(snapshot.data['email'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14),),
            currentAccountPicture: CircleAvatar(
                child: Image.network(snapshot.data['photoUrl'])
            ),
          ) ;
          final items = Column(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: header
              ),
              Expanded(
                  flex: 6,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Container(),
                  )
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Divider(),
                    ),
                    Expanded(
                      flex: 1,
                      child: SignInButton(
                        Buttons.Google,
                        text: '로그아웃',
                        onPressed: () {
                          Navigator.of(context).pop() ;
                          FireAuthProvider().signOut() ;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    )
                  ],
                )
              ),
            ],
          ) ;
          return Drawer(
            child: items,
          ) ;
        }
      }
    ) ;
  }


}