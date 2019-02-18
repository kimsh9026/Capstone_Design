class ChatRoom {

  String roomName ;
  String date ;
  String time ;
  int fullPeopleNumbers ;
  int currentPeopleNumbers ;

  ChatRoom(this.roomName, this.date, this.time, {this.fullPeopleNumbers=4, this.currentPeopleNumbers=1}) ;

  set setRoomName(String str){
    roomName = str ;
  }

  get getRoomName{
    return roomName ;
  }
}