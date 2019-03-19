import 'package:flutter/material.dart';
import 'package:capstone/test/BlocProvider.dart' ;
//import 'package:capstone/fixing/FixingBottomNavigation.dart';
import 'package:capstone/test/BottomNavigation.dart';
import 'package:capstone/test/ProfilePage.dart' ;
import 'package:capstone/test/FeedPage.dart' ;
import 'package:capstone/test/MatchingPage.dart' ;
import 'package:capstone/test/ChatRoomPage.dart' ;
/* 해결해야 할 것

* App 실행시 BlocProvider 생성
-> BlocProvider 에서 모든 Bloc() 생성
-> Performance 저하

* Theme 생성

 */

void main() => runApp(BlocProvider(child : MyApp())) ;

class MyApp extends StatelessWidget {

  static BottomNavigation botNavBar = BottomNavigation() ;
  ProfilePage profilePage = new ProfilePage(botNavBar) ;
  FeedPage feedPage = new FeedPage(botNavBar) ;
  MatchingPage matchingPage = new MatchingPage(botNavBar) ;
  ChatRoomPage chatRoomPage = new ChatRoomPage(botNavBar) ;

  @override
  Widget build(BuildContext context) {
    print("My App Build") ;
    return MaterialApp(
        title: 'Trabuddy',
        theme: new ThemeData(brightness: Brightness.light),
        home: new Scaffold(
          body: new StreamBuilder(
              stream : BlocProvider.of(context).bottomBarBloc.bottomBarPressed,
              builder: (context, snapshot) {
                if(!snapshot.hasData || snapshot.data == 0){
                  return profilePage ;
                }
                else if(snapshot.data == 1){
                  return feedPage ;
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