import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/BlocProvider.dart';
import 'package:capstone/bottom_navigation.dart';
import 'package:capstone/profie_page.dart';
import 'package:capstone/feed_page_codes/feed_page.dart';
import 'package:capstone/matching_page.dart';
import 'package:capstone/chat_room_codes/chat_room_page.dart';
import 'LogInPage.dart' ;
/* 해결해야 할 것

* App 실행시 BlocProvider 생성
-> BlocProvider 에서 모든 Bloc() 생성
-> Performance 저하

* Theme 생성

 */

void main() => runApp(BlocProvider(child : MyApp())) ;

class MyApp extends StatelessWidget {

  BottomNavigation botNavBar = BottomNavigation() ;
  ProfilePage profilePage = new ProfilePage() ;
  FeedPage feedPage = new FeedPage() ;
  MatchingPage matchingPage = new MatchingPage() ;
  ChatRoomPage chatRoomPage = new ChatRoomPage() ;
  LogInPage logInPage = new LogInPage() ;

  @override
  Widget build(BuildContext context) {
    print("My App Build") ;
    return MaterialApp(
      title: 'Trabuddy',
      theme: new ThemeData(
          brightness: Brightness.light,
          textTheme: TextTheme(
              title: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(47, 146, 217, 0.9),
              ),
              headline: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              ),
              body1: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 13.0,
              )
          )
      ),
      home: new StreamBuilder(
        stream: BlocProvider.of(context).authBloc.isLoggedIn,
        builder: (context, authSnapshot){
          print("streambuilder get") ;
          botNavBar.stateClear() ;
          return Scaffold(
            body: !authSnapshot.hasData ? logInPage :
            (
                authSnapshot.connectionState == ConnectionState.waiting ? splashScreen() :
                new StreamBuilder(
                    stream : BlocProvider.of(context).bottomBarBloc.bottomBarPressed,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData || snapshot.data == 0){
                        return profilePage ;
                      }
                      else if(snapshot.data == 1){
                        return matchingPage ;
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