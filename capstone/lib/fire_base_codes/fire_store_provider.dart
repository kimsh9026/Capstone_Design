import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/feed_page_codes/room_info.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance ;

  FirestoreProvider(){
    _firestore.settings(timestampsInSnapshotsEnabled: true) ;
  }

  void sendMessage(RoomInfo roomInfo, String msg){
    _firestore.collection('roomInfo')
        .document(roomInfo.documentID)
        .collection('Messages')
        .document()
        .setData({
      'message' : msg,
      'timestamp' : Timestamp.fromDate(DateTime.now()),
      'uid' : FireAuthProvider.user.uid,
    }) ;
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

  Future<DocumentSnapshot> getUserSnapshot(String uid){

    return _firestore.collection('userInfo')
        .document(uid).get() ;
  }

  Future<void> registerRoom(RoomInfo roomInfo) async {
    DateTime date = DateTime.now() ;
    return _firestore.collection('roomInfo').document().setData({
      'roomName' : roomInfo.roomName,
      'roomLeaderUID' : roomInfo.roomLeaderUID,
      'roomCreatedTime' : Timestamp.fromDate(date),
      'meetingDateTime' : roomInfo.meetingDateTime,
      'meetingLocation' : '경상북도 포항시 북구 양덕동',
//      'meetingLocation' : roomInfo.meetingLocation,
      'currentNumber' : 1,
      'users' : FieldValue.arrayUnion([FireAuthProvider.user.uid]),
      'totalNumber' : roomInfo.totalNumber,
      'roomPurpose' : roomInfo.roomPurpose,
//      'contents' : roomInfo.contents,
    }) ;
  }

  Future<bool> addUserInRoom(RoomInfo roomInfo) async {

    var doc = _firestore.collection('roomInfo').document(roomInfo.documentID);
    bool result ;
    await doc.get().then((DocumentSnapshot snapshot) async {
      result = await snapshot.data['users'].contains(FireAuthProvider.user.uid);
    }) ;

    if(result == true)
      return result ;

    final TransactionHandler handler = (Transaction tran) async {
      await tran.get(doc).then((DocumentSnapshot snapshot) async {
        if(snapshot.exists) {
          if(snapshot.data['currentNumber'] < snapshot.data['totalNumber']){
            await tran.update(doc, { 'currentNumber' : snapshot.data['currentNumber'] + 1}).whenComplete((){});
            print('number added') ;
            result = true ;
          }
          else {
            result = false;
          }
        }
      }) ;
    } ;
    await _firestore.runTransaction(handler)
    .whenComplete((){
      if(result) {
        _firestore.collection('roomInfo').document(roomInfo.documentID)
            .updateData({
          'users' : FieldValue.arrayUnion([FireAuthProvider.user.uid])
        }).whenComplete((){}) ;
      }
    }) ;
    print(result) ;
    return result ;
  }

  Stream<QuerySnapshot> chatRoomList(){
    return _firestore.collection('roomInfo')
        .where('users', arrayContains:FireAuthProvider.user.uid)
        .snapshots() ;
  }

}