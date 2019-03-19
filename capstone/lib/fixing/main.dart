import 'package:flutter/material.dart';
import 'package:capstone/fixing/BlocProvider.dart' ;
//import 'package:capstone/fixing/FixingBottomNavigation.dart';
import 'package:capstone/fixing/BottomNavigation.dart';
import 'package:capstone/fixing/ProfilePage.dart' ;
import 'package:capstone/fixing/FeedPage.dart' ;
import 'package:capstone/fixing/MatchingPage.dart' ;
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

  @override
  Widget build(BuildContext context) {
    print("My App Build") ;
    return MaterialApp(
        title: 'Trabuddy',
        theme: new ThemeData(brightness: Brightness.light),
        home: new StreamBuilder(
            stream : BlocProvider.of(context).centerBloc.bottomBarPressed,
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
                return matchingPage ;
              }
            }

//    BottomNavigation(),
          //ListUp(),
        )
    );
  }
}