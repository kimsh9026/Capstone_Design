
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomInfo {

  String _roomName = '' ;
  String _roomLeaderUID = '';
  String _joinedUserName = '' ;
  DateTime _roomCreatedTime = DateTime(0,0,0,0,0,0,0) ;
  DateTime _meetingDate = DateTime(0,0,0,0,0,0,0);
  DateTime _meetingTime = DateTime(0,0,0,0,0,0,0);
  String _meetingLocation = '';
  int _currentNumber = 0;
  int _totalNumber = 0;
  String _roomPurpose = '';
  String _contents = '' ;
  String _documentID = '' ;

  void clear(){
    _roomName = '' ;
    _roomLeaderUID = '';
    _meetingDate = DateTime(0,0,0,0,0,0,0);
    _meetingTime = DateTime(0,0,0,0,0,0,0);
    _totalNumber = 0;
    _currentNumber = 0;
    _roomPurpose = '';
    _meetingLocation = '';
    _contents = '' ;
    _roomCreatedTime = DateTime(0,0,0,0,0,0,0) ;
  }

  void setDocument(DocumentSnapshot document){
    print('here is room Info, setDocument') ;
    _roomName = document['roomName'] ;
    _roomLeaderUID = document['roomLeaderUID'] ;
    _roomCreatedTime = document['roomCreatedTime'].toDate() ;
    _documentID = document.documentID ;
  }

  String get documentID => _documentID;

  set documentID(String value) {
    _documentID = value;
  }

  String get joinedUserName => _joinedUserName;

  set joinedUserName(String value) {
    _joinedUserName = value;
  }

  String get meetingLocation => _meetingLocation;

  set meetingLocation(String value) {
    _meetingLocation = value;
  }

  String get roomName => _roomName;

  set roomName(String value) {
    _roomName = value;
  }

  String get roomLeaderUID => _roomLeaderUID;

  set roomLeaderUID(String value) {
    _roomLeaderUID = value;
  }

  DateTime get meetingDate => _meetingDate;

  set meetingDate(DateTime value) {
    _meetingDate = value;
  }

  DateTime get meetingTime => _meetingTime;

  set meetingTime(DateTime value) {
    _meetingTime = value;
  }

  int get totalNumber => _totalNumber;

  set totalNumber(int value) {
    _totalNumber = value;
  }

  int get currentNumber => _currentNumber;

  set currentNumber(int value) {
    _currentNumber = value;
  }

  String get roomPurpose => _roomPurpose;

  set roomPurpose(String value) {
    _roomPurpose = value;
  }

  Timestamp get meetingDateTime => Timestamp.fromDate(DateTime(meetingDate.year, meetingDate.month, meetingDate.day, meetingTime.hour, meetingTime.minute, meetingTime.second)) ;

  String get contents => _contents;

  set contents(String value) {
    _contents = value;
  }

  DateTime get roomCreatedTime => _roomCreatedTime;

  set roomCreatedTime(DateTime value) {
    _roomCreatedTime = value;
  }
}