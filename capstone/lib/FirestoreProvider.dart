import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/RoomInfo.dart' ;

class FirestoreProvider {

  Firestore _firestore = Firestore.instance ;

  //Firestore.instance.collection('roomInfo').snapshots() ;

  Stream<QuerySnapshot> get roomList => _firestore.collection('roomInfo').snapshots() ;

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
}

