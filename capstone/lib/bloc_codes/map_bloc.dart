import 'dart:async';

class MapBloc extends Object {

  final _simpleAddress = StreamController<String>.broadcast() ;
  final _detailAddress = StreamController<String>.broadcast() ;
  final _mapOff = StreamController<bool>.broadcast() ;

  Stream<String> get simpleAddress => _simpleAddress.stream ;
  Stream<String> get detailAddress => _detailAddress.stream ;
  Stream<bool> get mapOff => _mapOff.stream ;

  Function(String) get setSimpleAddress => _simpleAddress.sink.add ;
  Function(String) get setDetailAddress => _detailAddress.sink.add ;
  Function(bool) get setMapOff => _mapOff.sink.add ;

  dispose(){
    _simpleAddress.close() ;
    _detailAddress.close() ;
    _mapOff.close() ;
  }

}