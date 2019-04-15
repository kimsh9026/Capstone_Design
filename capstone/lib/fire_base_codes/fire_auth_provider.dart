import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:google_sign_in/google_sign_in.dart';

class FireAuthProvider {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes:[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]
  );

  FirebaseAuth _fireAuth = FirebaseAuth.instance ;
  FirebaseUser _user ;

  FirebaseUser get user => _user;

  Stream<FirebaseUser> get fireAuth => _fireAuth.onAuthStateChanged ;

  void _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("GoogleSignInAccount :  ${googleUser.toString()}") ;
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    print('GoogleSignInAuthentication : ${googleAuth.toString()}') ;
    final FirebaseUser user = await
    _fireAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    _user = user ;
  }

  void signOut(){
    _fireAuth.signOut() ;
    _googleSignIn.signOut() ;
    _user = null ;
  }

  void dispose(){
    signOut() ;
    _fireAuth = null ;
    _googleSignIn = null ;
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