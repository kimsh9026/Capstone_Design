import 'package:cloud_firestore/cloud_firestore.dart';
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
  static FirebaseUser _user ;

  static FirebaseUser get user => _user;

  Stream<FirebaseUser> get fireAuth => _fireAuth.onAuthStateChanged ;

  // error case to be solved: sometimes (may be when try log-in first time) google User is null.
  // temp solution : re-boot the emulator
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

    //if there is no info about current user in our fire base, add it.
    final QuerySnapshot result =
    await Firestore.instance.collection('userInfo').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance.collection('userInfo').document(user.uid).setData(
          {'nickname': user.displayName, 'photoUrl': user.photoUrl, 'id': user.uid, 'email': user.email});
    }
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