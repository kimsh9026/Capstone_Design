
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomInfo {

  String _roomName = '' ;
  String _roomLeaderName  = '';
  String _joinedUserName = '' ;
  DateTime _roomCreatedTime = DateTime(0,0,0,0,0,0,0) ;
  DateTime _meetingDate = DateTime(0,0,0,0,0,0,0);
  DateTime _meetingTime = DateTime(0,0,0,0,0,0,0);
  String _meetingLocation = '';
  int _currentNumber = 0;
  int _totalNumber = 0;
  String _roomPurpose = '';
  String _contents = '' ;

  void clear(){
    _roomName = '' ;
    _roomLeaderName  = '';
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
    _roomName = document['roomName'] ;
    _roomLeaderName = document['roomLeaderName'] ;
    _roomCreatedTime = document['roomCreatedTime'].toDate() ;
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

  String get roomLeaderName => _roomLeaderName;

  set roomLeaderName(String value) {
    _roomLeaderName = value;
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