import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuthProvider {

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes:[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]
  );

  FirebaseAuth _fireAuth = FirebaseAuth.instance ;

  Stream<FirebaseUser> get fireAuth => _fireAuth.onAuthStateChanged ;

  Future<FirebaseUser> _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    print("GoogleSignInAccount :  ${googleUser.toString()}") ;
    GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    print('GoogleSignInAuthentication : ${googleAuth.toString()}') ;
    final FirebaseUser user = await
    _fireAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user ;
  }

  void signOut(){
    googleSignIn.signOut() ;
    print('signed out') ;
  }

  void authenticate() {
    _authenticateWithGoogle() ;
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