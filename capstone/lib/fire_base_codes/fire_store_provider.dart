import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/feed_page_codes/room_info.dart';

class FirestoreProvider {

  /*
  roomInfo에 operator 선언해서
  roomInfo == null ?
  => roomInfo.name == '', roomInfo.date == ... 등

  * stream들 future로 안보내줘도 되나.. 로딩은?
   */

  Firestore _firestore = Firestore.instance ;

  FirestoreProvider(){
    _firestore.settings(timestampsInSnapshotsEnabled: true) ;
  }

  Stream<QuerySnapshot> feedRoomList(RoomInfo roomInfo) {

    if(roomInfo == null || roomInfo.roomName == ''){
      print('here is firestore, room list, FindingRoomName is null') ;
      return _firestore.collection('roomInfo').snapshots() ;
    }
    else{
      print('here is firestore, room list, FindingRoomName is ${roomInfo.roomName}') ;
      return _firestore.collection('roomInfo').where('roomName', isEqualTo: roomInfo.roomName).getDocuments().asStream() ;
    }
  }

  Stream<QuerySnapshot> getRoomMessages(RoomInfo roomInfo) {

    if(roomInfo == null){
      return null ;
    }
    else
      return _firestore.collection('roomInfo')
          .document(roomInfo.documentID)
          .collection('Messages')
          .orderBy('timestamp',descending: true)
          .limit(20)
          .snapshots() ;

  }

  Stream<DocumentSnapshot> getRoomSnapshot(RoomInfo roomInfo) {
    return _firestore.collection('roomInfo')
        .document(roomInfo.documentID).snapshots() ;
  }

  Future<void> registerRoom(RoomInfo roomInfo) async {
    DateTime date = DateTime.now() ;
    return _firestore.collection('roomInfo').document().setData({
      'roomName' : roomInfo.roomName,
      'roomLeaderUID' : roomInfo.roomLeaderUID,
      'roomCreatedTime' : Timestamp.fromDate(date),
      'meetingDateTime' : roomInfo.meetingDateTime,

      'meetingLocation' : '경상북도 포항시 북구 흥해읍',
//      'meetingLocation' : roomInfo.meetingLocation,
      'currentNumber' : 2,
//        'currentnumber' : roomInfo.currentNumber,
      'totalNumber' : 4,
//        'totalnumber' : roomInfo.totalNumber,
//      'roomPurpose' : roomInfo.roomPurpose,
//      'contents' : roomInfo.contents,
    }) ;
  }

  Future<void> addUserInRoom(RoomInfo roomInfo) {
    _firestore.collection('roomInfo').document(roomInfo.documentID)
        .updateData({
      'users' : FieldValue.arrayUnion([FireAuthProvider.user.uid])
    }) ;
  }

  Stream<QuerySnapshot> chatRoomList(){
    return _firestore.collection('roomInfo')
        .where('users', arrayContains:FireAuthProvider.user.uid)
        .snapshots() ;
  }

}