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

    if(roomInfo == null || roomInfo.roomName == ''){
      print('here is firestore, room list, FindingRoomName is null') ;
      return _firestore.collection('roomInfo').snapshots() ;
    }
    else{
      print('here is firestore, room list, FindingRoomName is ${roomInfo.roomName}') ;
      return _firestore.collection('roomInfo').where('roomName', isEqualTo: roomInfo.roomName).getDocuments().asStream() ;
    }
  }

  Stream<QuerySnapshot> roomMessages(RoomInfo roomInfo) {
    if(roomInfo == null){
      print('here is fire store, room Messages, and roomInfo is null') ;
      return null ;
    }
    else
      print('here is fire store, room Messages, and Created time is : ${Timestamp.fromDate(roomInfo.roomCreatedTime)}') ;
      _firestore.collection('roomMessages')
          .where('roomName', isEqualTo: roomInfo.roomName)
          .where('roomLeaderName', isEqualTo: roomInfo.roomLeaderName)
//          .where('roomCreatedTime', isEqualTo: Timestamp.fromDate(roomInfo.roomCreatedTime))
          .getDocuments()
          .then((value) {

        _firestore.collection('roomMessages')
            .document(value.documents.elementAt(0).documentID)
            .collection('Messages')
            .orderBy('timestamp',descending: true)
            .limit(20)
            .getDocuments().then((value){
              print(value.documents[0]['message'].toString());
        }) ;

        return _firestore.collection('roomMessages')
            .document(value.documents.elementAt(0).documentID)
            .collection('Messages')
            .orderBy('timestamp',descending: true)
            .limit(20)
            .getDocuments().asStream() ;
      }
      ) ;
  }

  Future<void> registerRoom(RoomInfo roomInfo) async {
    DateTime date = DateTime.now() ;
    _firestore.collection('roomInfo').document().setData({
      'roomName' : roomInfo.roomName,
      'roomLeaderName' : roomInfo.roomLeaderName,
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

    return _firestore.collection('roomMessages').document().setData({
      'roomName' : roomInfo.roomName,
      'roomLeaderName' : roomInfo.roomLeaderName,
      'roomCreatedTime' : Timestamp.fromDate(date),
    }) ;

  }

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
