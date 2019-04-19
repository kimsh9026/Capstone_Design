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

  Stream<QuerySnapshot> roomList(RoomInfo roomInfo) {
    print('here is firestore list') ;
    if(roomInfo == null || roomInfo.roomName == '')
    return _firestore.collection('roomInfo').snapshots() ;
   else
     return _firestore.collection('roomInfo').where('name', isEqualTo: roomInfo.roomName).getDocuments().asStream() ;
  }

  Future<void> registerRoom(RoomInfo roomInfo) async {

    return _firestore.collection('roomInfo').document().setData({
      'roomName' : roomInfo.roomName,
      'roomLeaderName' : roomInfo.roomLeaderName,
      'roomCreatedTime' : Timestamp.fromDate(DateTime.now()),
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

  Stream<QuerySnapshot> roomMessages(RoomInfo roomInfo) {
    print('here is firestore roomMessages') ;
    print('roomName, isEqualTo: ${roomInfo.roomName}') ;
    print('roomLeaderName, isEqualTo: ${roomInfo.roomLeaderName}') ;
    print('roomCreatedTime, isEqualTo: ${roomInfo.roomCreatedTime}') ;

    if(roomInfo == null)
      return null ;
    else
      return _firestore.collection('roomMessages') //.where('name', isEqualTo: name).reference().
          .where('roomName', isEqualTo: roomInfo.roomName)
          .where('roomLeaderName', isEqualTo: roomInfo.roomLeaderName)
//          .where('roomCreatedTime', isEqualTo: roomInfo.roomCreatedTime)
          .getDocuments().asStream() ;

  }



//  Future<void> sendMessage(RoomInfo roomInfo, String msg){
//    _firestore.collection('roomInfo').document(roomInfo.roomName).collection('messages')
//  }

//  Stream<QuerySnapshot> searchRoom(RoomInfo roomInfo) {
//   return _firestore.collection('roomInfo').where('name', isEqualTo: roomInfo.roomName).getDocuments().asStream() ;
//  }
}

/* warning message : if upgraded version of firestore break our codes, than try adding this.
W/Firestore( 8276): FirebaseFirestore firestore = FirebaseFirestore.getInstance();
W/Firestore( 8276): FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
W/Firestore( 8276):     .setTimestampsInSnapshotsEnabled(true)
W/Firestore( 8276):     .build();
W/Firestore( 8276): firestore.setFirestoreSettings(settings);

W/Firestore( 8276): // Old:
W/Firestore( 8276): java.util.Date date = snapshot.getDate("created_at");
W/Firestore( 8276): // New:
W/Firestore( 8276): Timestamp timestamp = snapshot.getTimestamp("created_at");
W/Firestore( 8276): java.util.Date date = timestamp.toDate();
 */
