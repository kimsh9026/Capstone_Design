import 'package:flutter/material.dart';
import 'package:capstone/fixing/BlocProvider.dart' ;
import 'package:capstone/fixing/FixingBottomNavigation.dart';

/* 해결해야 할 것

* App 실행시 BlocProvider 생성
-> BlocProvider 에서 모든 Bloc() 생성
-> Performance 저하

* Theme 생성

 */


void main() => runApp(BlocProvider(child : MyApp())) ;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabuddy',
      theme: new ThemeData(brightness: Brightness.light),
      home: BottomNavigation(),
      //ListUp(),
    );
  }
}