import 'package:flutter/material.dart' ;
import 'package:capstone/feed_page_codes/FeedPage.dart';
import 'dart:async';

class CenterBloc extends Object{

  BuildContext _context ;

  final _bottomBarPressed = StreamController<String>.broadcast() ;

  Stream<String> get bottomBarPressed => _bottomBarPressed.stream ;

  Function(String) get setBottomBarPressed => _bottomBarPressed.sink.add ;

  CenterBloc(){
    bottomBarPressed.listen((String page) {
      print("barPage : $page") ;
      if(_context != null){
        Navigator.pushReplacement(
          _context,
          PageRouteBuilder(
            pageBuilder: (_context1, animation1, animation2) {
              if(page == 'FeedPage');
  //            return FeedPage();
            },
//            transitionsBuilder: (_context, animation, _, child) {
//              return new SlideTransition(
//                child: child,
//                position: new Tween<Offset>(
//                  begin: !result ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
//                  end: Offset.zero,
//                ).animate(animation),
//              );
//            },
            //transitionDuration: Duration(milliseconds: 500),
          ),
        );
      }
    },onError: (error) {
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text(error.message),
      ));
    });
  }

}