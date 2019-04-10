import 'package:flutter/material.dart' ;
import 'dart:async';


class AuthBloc extends Object {
  final _isLogIn = StreamController<bool>.broadcast() ;
//  final _logIn
  Stream<bool> get islogIn => _isLogIn.stream ;

  Function(bool) get setIslogIn => _isLogIn.sink.add ;
}