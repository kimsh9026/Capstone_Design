import 'package:capstone/main.dart';
import 'package:flutter/material.dart' ;
import 'dart:async';

class BottomBarBloc extends Object{

  BuildContext _context ;
  bool isMatching = false ;
  final _bottomBarPressed = StreamController<int>.broadcast() ;
  final _matchingStart = StreamController<bool>.broadcast() ;

  Stream<int> get bottomBarPressed => _bottomBarPressed.stream ;
  Stream<bool> get matchingStart => _matchingStart.stream ;

  Function(int) get setBottomBarPressed => _bottomBarPressed.sink.add ;
  Function(bool) get setMatchingStart => _matchingStart.sink.add ;

  BottomBarBloc(){
    bottomBarPressed.listen((int index) {
      MyApp.botNavBar.animate(index) ;
      }
    ,onError: (error) {
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text(error.message),
      ));
    });
    matchingStart.listen((bool value) {
      if(value){
        isMatching = true ;
        MyApp.isMatching = true ;
        setBottomBarPressed(1) ;
      }
      else if(!value){
        isMatching = false ;
        MyApp.isMatching = false;
      }
    }
        ,onError: (error) {
          Scaffold.of(_context).showSnackBar(new SnackBar(
            content: new Text(error.message),
          ));
        });

  }

  dispose(){
    _bottomBarPressed.close() ;
    _matchingStart.close() ;
  }

}