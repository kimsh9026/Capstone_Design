import 'dart:async';

class CreateRoomBloc extends Object{

  final _pressedButtonIndex = StreamController<int>.broadcast() ;
  final _memberNumberChanged = StreamController<bool>.broadcast() ;

  Stream<int> get pressedButtonIndex => _pressedButtonIndex.stream ;
  Stream<bool> get memberNumberChanged => _memberNumberChanged.stream ;

  Function(int) get setPressedButtonIndex => _pressedButtonIndex.sink.add ;
  Function(bool) get setMemberNumberChanged => _memberNumberChanged.sink.add ;

  dispose(){
    _pressedButtonIndex.close() ;
    _memberNumberChanged.close() ;
  }
}