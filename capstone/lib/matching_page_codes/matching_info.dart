
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/places.dart';

class MatchingInfo {

  Location _location ;
  int _number ;
  String _purpose ;
  String _locationName ;
  String _country ;
  double _boundary ;
  GeoPoint _geoPoint ;
  PlacesSearchResult _placesSearchResult ;

  MatchingInfo(){
    _country = '대한민국' ;
    _boundary = 0.4 ;
  }

  PlacesSearchResult get placesSearchResult => _placesSearchResult;

  set placesSearchResult(PlacesSearchResult value) {
    _placesSearchResult = value;
    _location = value.geometry.location ;
    _locationName = value.name ;
    _geoPoint = GeoPoint(value.geometry.location.lat, value.geometry.location .lng) ;
  }

  Location get location => _location;
  String get locationName => _locationName;
  GeoPoint get geoPoint => _geoPoint;

  String get purpose => _purpose;

  set purpose(String value) {
    _purpose = value;
  }

  double get boundary => _boundary;

  set boundary(double value) {
    _boundary = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  int get number => _number;

  set number(int value) {
    _number = value;
  }

}