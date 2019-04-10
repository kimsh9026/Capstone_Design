import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/RoomInfo.dart' ;

class FirestoreProvider {

  /*
  roomInfo에 operator 선언해서
  roomInfo == null ?
  => roomInfo.name == '', roomInfo.date == ... 등
   */

  Firestore _firestore = Firestore.instance ;
  Stream<QuerySnapshot> _roomList = Firestore.instance.collection('roomInfo').snapshots() ;

  Stream<QuerySnapshot> roomList(RoomInfo roomInfo) {
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

//  Stream<QuerySnapshot> searchRoom(RoomInfo roomInfo) {
//   return _firestore.collection('roomInfo').where('name', isEqualTo: roomInfo.roomName).getDocuments().asStream() ;
//  }
}

/* warning message
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
