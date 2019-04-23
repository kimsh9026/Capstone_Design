import 'package:flutter/material.dart' ;
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'dart:async';


class AuthBloc extends Object {

  final _isLoggedIn = FireAuthProvider().fireAuth;

  Stream<FirebaseUser> get isLoggedIn => _isLoggedIn ;

}