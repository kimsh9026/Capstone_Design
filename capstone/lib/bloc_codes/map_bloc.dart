import 'dart:async';

import 'package:capstone/matching_page_codes/matching_info.dart';
import 'package:google_maps_webservice/places.dart';

class MapBloc extends Object {

  final _searchResponse = StreamController<MatchingInfo>.broadcast() ;
  final _detailAddress = StreamController<String>.broadcast() ;
  final _mapOff = StreamController<bool>.broadcast() ;
  final _radius = StreamController<double>.broadcast() ;

  Stream<MatchingInfo> get searchResponse => _searchResponse.stream ;
  Stream<String> get detailAddress => _detailAddress.stream ;
  Stream<bool> get mapOff => _mapOff.stream ;
  Stream<double> get radius => _radius.stream ;

  Function(MatchingInfo) get setSearchResponse => _searchResponse.sink.add ;
  Function(String) get setDetailAddress => _detailAddress.sink.add ;
  Function(bool) get setMapOff => _mapOff.sink.add ;
  Function(double) get setRadius => _radius.sink.add ;

  dispose(){
    _radius.close() ;
    _searchResponse.close() ;
    _detailAddress.close() ;
    _mapOff.close() ;
  }

}