import 'package:flutter/material.dart' ;
import 'dart:async';

class BottomBarBloc extends Object{

  BuildContext _context ;

  final _bottomBarPressed = StreamController<int>.broadcast() ;
  final _bottomBarAnimation = StreamController<Function>.broadcast() ;

  Stream<int> get bottomBarPressed => _bottomBarPressed.stream ;
  Stream<Function> get bottomBarAnimation => _bottomBarAnimation.stream ;

  Function(Function) get setBottomBarAnimation => _bottomBarAnimation.sink.add ;
  Function(int) get setBottomBarPressed => _bottomBarPressed.sink.add ;

  BottomBarBloc(){
    bottomBarPressed.listen((int index) {
      print("Pressed : $index");
      }
    ,onError: (error) {
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text(error.message),
      ));
    });
  }

}