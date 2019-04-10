import 'package:flutter/material.dart' ;
import 'dart:async';


class AuthBloc extends Object {
  final _logIn = StreamController<bool>.broadcast() ;

  Stream<bool> get logIn => _logIn.stream ;

  Function(bool) get setlogIn => _logIn.sink.add ;
}