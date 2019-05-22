import 'package:cloud_firestore/cloud_firestore.dart';

class USER {
  String id;
  String photoUrl;
  String nickname;
  String status;
  int age;
  String gender;
  String language;
  String contact;
  String intro;

  USER();

  USER.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data['id'];
    photoUrl = snapshot.data['photoUrl'];
    nickname = snapshot.data['nickname'];
    status = snapshot.data['status'];
    age = snapshot.data['age'];
    gender = snapshot.data['gender'];
    language = snapshot.data['language'];
    contact= snapshot.data['contact'];
    intro = snapshot.data['intro'];
  }
}