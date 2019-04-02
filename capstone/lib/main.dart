import 'package:flutter/material.dart';
import 'package:capstone/BlocProvider.dart';
//import 'package:capstone/fixing/FixingBottomNavigation.dart';
import 'package:capstone/BottomNavigation.dart';
import 'package:capstone/ProfilePage.dart';
import 'package:capstone/FeedPage.dart';
import 'package:capstone/MatchingPage.dart';
import 'package:capstone/ChatRoomPage.dart';
/* 해결해야 할 것

* App 실행시 BlocProvider 생성
-> BlocProvider 에서 모든 Bloc() 생성
-> Performance 저하

* Theme 생성

 */

void main() => runApp(BlocProvider(child : MyApp())) ;

class MyApp extends StatelessWidget {

  static BottomNavigation botNavBar = BottomNavigation() ;
  ProfilePage profilePage = new ProfilePage() ;
  FeedPage feedPage = new FeedPage(botNavBar) ;
  MatchingPage matchingPage = new MatchingPage(botNavBar) ;
  ChatRoomPage chatRoomPage = new ChatRoomPage(botNavBar) ;

  @override
  Widget build(BuildContext context) {
    print("My App Build") ;
    return MaterialApp(
        title: 'Trabuddy',
        theme: new ThemeData(
          brightness: Brightness.light,
//          primaryColor: Color.fromRGBO(61, 174, 218, 0),
          textTheme: TextTheme(
            headline: TextStyle(

                fontWeight: FontWeight.w400,
                fontSize: 17.0,
//                height: 0
            ),
            body1: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13.0,
            )
          )
        ),
        home: new Scaffold(
          body: new StreamBuilder(
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
              }),
          bottomNavigationBar: botNavBar,


//    BottomNavigation(),
          //ListUp(),
        )
    );
  }
}