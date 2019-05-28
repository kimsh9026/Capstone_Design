import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/main.dart';
import 'package:capstone/matching_page_codes/matching_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/feed_page_codes/room_info.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance ;

  FirestoreProvider(){
    _firestore.settings(timestampsInSnapshotsEnabled: true) ;
  }

  Stream<DocumentSnapshot> getCurrentUserInfo(){
    return _firestore.collection('userInfo')
        .document(FireAuthProvider.user.uid).snapshots() ;
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

  Future<DocumentReference> startMatching(MatchingInfo info){
    return _firestore.collection('matchingInfo').add({
      'uid' : FireAuthProvider.user.uid,
      'geoPoint' : info.geoPoint,
      'country' : info.country,
      'meetingLocation' : info.locationName,
      'boundary' : info.boundary,
      'roomPurpose' : info.purpose,
      'totalNumber' : info.number,
      'startTime' : Timestamp.now(),
      'vicinity' : info.placesSearchResult.vicinity,
    }) ;
  }

  void checkMatching() async {
    if(FireAuthProvider.user != null){
      QuerySnapshot result = await _firestore.collection('matchingInfo').where('uid', isEqualTo: FireAuthProvider.user.uid).getDocuments() ;
      bool matching = result.documents.length == 0 ? false : true;
      MyApp.isMatching = matching ;
    }
  }

  Stream<QuerySnapshot> matchingStream(){
    if(FireAuthProvider.user != null){
      return _firestore.collection('matchingInfo')
          .where('uid', isEqualTo:FireAuthProvider.user.uid)
          .snapshots() ;
    }

  }

  Stream<QuerySnapshot> feedRoomList(RoomInfo roomInfo) {

    if(roomInfo == null || roomInfo.roomName == ''){
      return _firestore.collection('roomInfo').snapshots() ;
    }
    else{
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

  Stream<DocumentSnapshot> getUserStream(String uid){
    return _firestore.collection('userInfo').document(uid).snapshots() ;
  }

  Future<void> registerRoom(RoomInfo roomInfo) async {
    DateTime date = DateTime.now() ;
    return _firestore.collection('roomInfo').document().setData({
      'roomName' : roomInfo.roomName,
      'roomLeaderUID' : roomInfo.roomLeaderUID,
      'roomCreatedTime' : Timestamp.fromDate(date),
      'meetingDateTime' : roomInfo.meetingDateTime,
      'meetingLocation' : roomInfo.meetingLocation,
      'currentNumber' : 1,
      'users' : FieldValue.arrayUnion([FireAuthProvider.user.uid]),
      'totalNumber' : roomInfo.totalNumber,
      'roomPurpose' : roomInfo.roomPurpose,
      'location' : GeoPoint(roomInfo.location.lat, roomInfo.location.lng),
      'vicinity' : roomInfo.vicinity,
      'country' : roomInfo.country,
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

  Future<void> exitMatching() async {
    DocumentReference doc ;
    await _firestore.collection('matchingInfo').where('uid', isEqualTo: FireAuthProvider.user.uid)
      .getDocuments().then((value){
        if(value.documents.length != 0){
          doc = value.documents[0].reference ;
        }
    });
    if(doc == null){
      return ;
    }

    final TransactionHandler handler = (Transaction tran) async {
      await tran.get(doc).then((DocumentSnapshot snapshot) async {
        if(snapshot.exists) {
          await tran.delete(doc) ;
        }
        else{
//          return ;
        }
      }) ;
    } ;
    await _firestore.runTransaction(handler) ;
  }

  Future<void> exitRoom(RoomInfo roomInfo) async {

    var doc = _firestore.collection('roomInfo').document(roomInfo.documentID);
    bool delete;
    await doc.get().then((DocumentSnapshot snapshot) async {
      delete = await snapshot.data['users'].contains(FireAuthProvider.user.uid);
    }) ;

    if(delete == false)
      return delete ;

    final TransactionHandler handler = (Transaction tran) async {
      await tran.get(doc).then((DocumentSnapshot snapshot) async {
        if(snapshot.exists) {
          if(snapshot.data['roomLeaderUID'] == FireAuthProvider.user.uid){
            await tran.delete(doc) ;
            delete = true ;
          }
          else if(snapshot.data['currentNumber'] > 1){
            await tran.update(doc, { 'currentNumber' : snapshot.data['currentNumber'] - 1}).whenComplete((){});
            delete = false ;
          }
          else {
            delete = true ;
            await tran.delete(doc) ;
          }
        }
      }) ;
    } ;
    await _firestore.runTransaction(handler)
        .whenComplete((){
      if(!delete) {
        _firestore.collection('roomInfo').document(roomInfo.documentID)
            .updateData({
          'users' : FieldValue.arrayRemove([FireAuthProvider.user.uid])
        }).whenComplete((){}) ;
      }
    }) ;
//    return result ;
  }

}