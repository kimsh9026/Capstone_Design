import 'package:flutter/material.dart';
import 'package:capstone/BLoCPattern/bloc_provider.dart' ;
import 'package:capstone/BLoCPattern/navigation_example.dart' ;

void main() => runApp(BlocProvider(child : MyApp())) ;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabuddy',
      theme: new ThemeData(brightness: Brightness.light),
      home: BottomNavigationDemo(),
      //ListUp(),
    );
  }
}