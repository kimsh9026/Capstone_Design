import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/matching_page_codes/matching_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/bottom_navigation.dart';
import 'package:capstone/feed_page_codes/feed_page.dart';
import 'package:capstone/matching_page_codes/matching_page.dart';
import 'package:capstone/chat_room_codes/my_chat_room_page.dart';
import 'package:capstone/LogInPage.dart' ;
import 'package:capstone/FriendList.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

void main() => runApp(BlocProvider(child : MyApp())) ;

class MyApp extends StatelessWidget {

  static bool isMatching = false ;
  static BottomNavigation botNavBar = BottomNavigation() ;
  FriendListPage friendListPage = new FriendListPage();
  FeedPage feedPage = new FeedPage() ;
  MatchingPage matchingPage = new MatchingPage() ;
  MyChatRoomPage chatRoomPage = new MyChatRoomPage() ;
  LogInPage logInPage = new LogInPage() ;
  FireAuthProvider auth = new FireAuthProvider() ;
  void _checkMatching(){
    FirestoreProvider().checkMatching() ;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabuddy',
      theme: new ThemeData(
        fontFamily: 'NotoSans',
          brightness: Brightness.light,
          textTheme: TextTheme(
              title: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(47, 146, 217, 0.9),
              ),
              headline: TextStyle(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              ),
              body1: TextStyle(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w300,
                fontSize: 13.0,
              )
          )
      ),
      home: new StreamBuilder(
        stream: BlocProvider.of(context).authBloc.isLoggedIn,
        builder: (context, authSnapshot){
          _checkMatching() ;
          if(!authSnapshot.hasData) botNavBar.stateClear;
          return Scaffold(
            body: !authSnapshot.hasData ? logInPage :
            (
                authSnapshot.connectionState == ConnectionState.waiting ? splashScreen() :
                new StreamBuilder(
                    stream : BlocProvider.of(context).bottomBarBloc.bottomBarPressed,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData || snapshot.data == 0){
                        return friendListPage ;
                        //return profilePage;
                      }
                      else if(snapshot.data == 1){
                        return isMatching ? MatchingScreen() : matchingPage ;
                      }
                      else if(snapshot.data == 2){
                        return feedPage ;
                      }
                      else if(snapshot.data == 3){
                        return chatRoomPage ;
                      }
                    }
                )
            ),
            bottomNavigationBar: !authSnapshot.hasData ? null: botNavBar,
          ) ;
        },
      ),
    );
  }


  Widget splashScreen(){
    return Scaffold(
      appBar : AppBar(title: Text('loading')),
      body: Center(child: Text('loading'),),
    );
  }
}