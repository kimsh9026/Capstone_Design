import 'package:cloud_firestore/cloud_firestore.dart';

class USER {
  String email;
  DateTime id;
  DateTime nickname;
  String photoUrl;
  String status;
  String hobby;
  String intro;

  USER();

  USER.fromSnapshot(DocumentSnapshot snapshot) {
    email = snapshot.data['email'];
    id = snapshot.data['id'];
    nickname = snapshot.data['nickname'];
    photoUrl = snapshot.data['photoUrl'];
    status = snapshot.data['status'];
    hobby = snapshot.data['hobby'];
    intro = snapshot.data['intro'];
  }
}