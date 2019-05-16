import 'dart:async';

class MapBloc extends Object {

  final _simpleAddress = StreamController<String>.broadcast() ;
  final _detailAddress = StreamController<String>.broadcast() ;

  Stream<String> get simpleAddress => _simpleAddress.stream ;
  Stream<String> get detailAddress => _detailAddress.stream ;

  Function(String) get setSimpleAddress => _simpleAddress.sink.add ;
  Function(String) get setDetailAddress => _detailAddress.sink.add ;

  dispose(){
    _simpleAddress.close() ;
    _detailAddress.close() ;
  }

}