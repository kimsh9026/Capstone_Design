import 'dart:async';

class MapBloc extends Object {

  final _simpleAddress = StreamController<String>.broadcast() ;
  final _detailAddress = StreamController<String>.broadcast() ;
  final _mapOff = StreamController<bool>.broadcast() ;
  final _radius = StreamController<double>.broadcast() ;

  Stream<String> get simpleAddress => _simpleAddress.stream ;
  Stream<String> get detailAddress => _detailAddress.stream ;
  Stream<bool> get mapOff => _mapOff.stream ;
  Stream<double> get radius => _radius.stream ;

  Function(String) get setSimpleAddress => _simpleAddress.sink.add ;
  Function(String) get setDetailAddress => _detailAddress.sink.add ;
  Function(bool) get setMapOff => _mapOff.sink.add ;
  Function(double) get setRadius => _radius.sink.add ;

  dispose(){
    _radius.close() ;
    _simpleAddress.close() ;
    _detailAddress.close() ;
    _mapOff.close() ;
  }

}