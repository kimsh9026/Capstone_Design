class ChatRoom {

  String roomName ;
  String date ;
  String time ;
  int fullPeopleNumbers ;
  int currentPeopleNumbers ;
  String _explaination ;
  var _Images ;

  get Images => _Images;

  set Images(value) {
    _Images = value;
  }

  String get explaination => _explaination;

  set explaination(String value) {
    _explaination = value;
  }

  ChatRoom(this.roomName, this.date, this.time, {this.fullPeopleNumbers=4, this.currentPeopleNumbers=1}) ;

  set setRoomName(String str){
    roomName = str ;
  }

  get getRoomName{
    return roomName ;
  }
}