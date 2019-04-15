import 'package:capstone/bloc_codes/BlocProvider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:flutter/material.dart';
//import 'package:capstone/test/chat_room_info.dart' ;
import 'package:capstone/bottom_navigation.dart';

class MatchingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("MatchingPage Build") ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Page'),
        actions:
        <Widget>[
          PopupMenuButton<BottomNavigationBarType>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: Text('Something1'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: Text('something2'),
              )
            ],
          )
        ],

      ),
      body: Center(
        child : Container(
          color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
          child: Center(child: Column(
            children: <Widget>[
              Text(
                'Matching..',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.white,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              RaisedButton(
                  child: Text('Sign out with Google'),
                  onPressed: (){
                    FireAuthProvider().signOut() ;
                    BlocProvider.of(context).authBloc.setLogIn(false) ;
                  }
              )
            ],
          )),
        ),
      ),
//      bottomNavigationBar: botNavBar,
    );



  }
}