class RoomInfo {

  String _roomName = '' ;
  String _roomLeaderName  = '';
  DateTime _date = DateTime.now();
  DateTime _time = DateTime.now();
  int _totalNumber = 0;
  int _currentNumber = 0;
  String _roomPurpose = '';

  String get roomName => _roomName;

  set roomName(String value) {
    _roomName = value;
  }

  String get roomLeaderName => _roomLeaderName;

  set roomLeaderName(String value) {
    _roomLeaderName = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  DateTime get time => _time;

  set time(DateTime value) {
    _time = value;
  }

  int get totalNumber => _totalNumber;

  set totalNumber(int value) {
    _totalNumber = value;
  }

  int get currentNumber => _currentNumber;

  set currentNumber(int value) {
    _currentNumber = value;
  }

  String get roomPurpose => _roomPurpose;

  set roomPurpose(String value) {
    _roomPurpose = value;
  }

  DateTime get dateNTime => DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second) ;

  void clear(){
    _roomName = null ;
    _roomLeaderName = null ;
    _date = null ;
    _time = null ;
    _totalNumber = null ;
    _currentNumber = null ;
    _roomPurpose = null;
  }
}