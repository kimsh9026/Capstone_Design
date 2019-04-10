import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuthProvider {
  FirebaseAuth _fireAuth = FirebaseAuth.instance ;

  Stream<FirebaseUser> get fireAuth => _fireAuth.onAuthStateChanged ;



  FireAuthProvider(){
//sdkjsdij
  }
  /* use
  if (snapshot.connectionState == ConnectionState.waiting) {
          return new SplashScreen();
        } else {
          if (snapshot.hasData) {
            return new MainScreen(firestore: firestore,
                uuid: snapshot.data.uid);
          }
          return new LoginScreen();
   */


}