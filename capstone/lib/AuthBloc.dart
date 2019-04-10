import 'package:flutter/material.dart' ;
import 'dart:async';


class AuthBloc extends Object {
  final _islogIn = StreamController<bool>.broadcast() ;
//  final _logIn
  Stream<bool> get islogIn => _islogIn.stream ;

  Function(bool) get setIslogIn => _islogIn.sink.add ;
}