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
  Stream<QuerySnapshot> _roomList = Firestore.instance.collection('roomInfo').snapshots() ;

  Stream<QuerySnapshot> roomList(RoomInfo roomInfo) {
//    print(_firestore.collection('roomInfo').document('hellow worlds!!').collection('messages').where('uid', isEqualTo: 'sdsd').snapshots().toList());
    print('here is firestore list') ;
    if(roomInfo == null || roomInfo.roomName == '')
    return _roomList;
   else
     return _firestore.collection('roomInfo').where('name', isEqualTo: roomInfo.roomName).getDocuments().asStream() ;
  }

  Future<void> registerRoom(RoomInfo roomInfo) async {

    return _firestore.collection('roomInfo').document().setData({
      'name' : roomInfo.roomName,
      'dateNtime' : roomInfo.dateNTime,
      'currentnumber' : 2,
//        'currentnumber' : roomInfo.currentNumber,
      'totalnumber' : 4,
//        'totalnumber' : roomInfo.totalNumber,
    }) ;
  }

  Stream<QuerySnapshot> enterRoom(String name) {
    print('here is fire store: ${name}') ;
    if(name == null || name == '')
      return null ;
    else
      return _firestore.collection('roomInfo') //.where('name', isEqualTo: name).reference().
          .document(name)
          .collection('messages')
          .orderBy('time' , descending: true)
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
