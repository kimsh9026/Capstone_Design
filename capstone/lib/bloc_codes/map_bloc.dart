import 'dart:async';
import 'package:capstone/matching_page_codes/matching_info.dart';
//import 'package:google_maps_webservice/places.dart';

class MapBloc extends Object {

  final _searchResponse = StreamController<MatchingInfo>.broadcast() ;
  final _detailAddress = StreamController<String>.broadcast() ;
  final _mapOff = StreamController<bool>.broadcast() ;
  final _radius = StreamController<double>.broadcast() ;
  final _location = StreamController<Map<String,dynamic>>.broadcast() ;
  final _addRoomMapOff = StreamController<bool>.broadcast() ;
  final _searchingOfLoading = StreamController<bool>.broadcast() ;
  final _mapControl = StreamController<Map<String,dynamic>>.broadcast() ;

  Stream<MatchingInfo> get searchResponse => _searchResponse.stream ;
  Stream<String> get detailAddress => _detailAddress.stream ;
  Stream<bool> get mapOff => _mapOff.stream ;
  Stream<double> get radius => _radius.stream ;
  Stream<Map<String,dynamic>> get location => _location.stream ;
  Stream<bool> get addRoomMapOff => _addRoomMapOff.stream ;
  Stream<bool> get searchingOrLoading => _searchingOfLoading.stream ;
  Stream<Map<String,dynamic>> get mapControl => _mapControl.stream ;

  Function(MatchingInfo) get setSearchResponse => _searchResponse.sink.add ;
  Function(String) get setDetailAddress => _detailAddress.sink.add ;
  Function(bool) get setMapOff => _mapOff.sink.add ;
  Function(double) get setRadius => _radius.sink.add ;
  Function(Map<String,dynamic>) get setLocation => _location.sink.add ;
  Function(bool) get setAddRoomMapOff => _addRoomMapOff.sink.add ;
  Function(bool) get setSearchingOrLoading => _searchingOfLoading.sink.add ;
  Function(Map<String, dynamic>) get setMapControl => _mapControl.sink.add ;

  dispose(){
    _radius.close() ;
    _searchResponse.close() ;
    _detailAddress.close() ;
    _mapOff.close() ;
    _location.close() ;
    _addRoomMapOff.close() ;
    _searchingOfLoading.close() ;
    _mapControl.close() ;
  }

}