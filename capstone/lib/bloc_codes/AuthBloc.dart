import 'package:flutter/material.dart' ;
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'dart:async';


class AuthBloc extends Object {

  final _isLoggedIn = FireAuthProvider().fireAuth;
  final _logIn = StreamController<bool>.broadcast() ;

  Stream<FirebaseUser> get isLoggedIn => _isLoggedIn ;
  Stream<bool> get logIn => _logIn.stream ;

  Function(bool) get setLogIn => _logIn.sink.add ;

//  Function(bool) get setlogIn => _logIn.sink.add ;

  dispose(){
    _logIn.close() ;
  }

}