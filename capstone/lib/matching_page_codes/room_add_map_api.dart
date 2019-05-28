import 'dart:async';

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/matching_page_codes/full_screen_map_api.dart';
import 'package:capstone/matching_page_codes/matching_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCWiFLiauFZv-cMSqXX_f4mRTn9rYd6ssw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class RoomAddMapApi extends StatefulWidget {
  @override
  State<RoomAddMapApi> createState() => RoomAddMapApiState();
}

class RoomAddMapApiState extends State<RoomAddMapApi> {

  GoogleMapController _mapController;
  Position _currentLocation ;
  LatLng _center = LatLng(0,0) ;
  bool isLoading = false;
  bool isSearching = false ;
  bool isOn = false;
  PlacesSearchResult _placeMark ;
  String _country = '';
  Set<Marker> _markers = Set<Marker>();
  double _cameraZoom = 16 ;
  BuildContext _context ;

  @override
  void initState() {
    super.initState();
    _mapController = null ;
    _currentLocation = null ;
    _center = LatLng(0,0) ;
    isLoading = false ;
    isSearching = false ;
    isOn = false ;
    _country = '';
    _markers = Set<Marker>();
    _cameraZoom = 16 ;
    _context = null ;
    _markers.add(Marker(markerId: MarkerId('default'))) ;
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    Map<String, dynamic> init = Map<String,dynamic>() ;
    _currentLocation = await locateUser();
    _places.searchNearbyWithRadius(Location(_currentLocation.latitude, _currentLocation.longitude), 2500)
        .then((value){
      Geolocator().placemarkFromCoordinates(value.results[0].geometry.location.lat, value.results[0].geometry.location.lng)
          .then((result) {
        _country = result[0].country ;
        init['name'] = value.results[0].name ;
        init['center'] = LatLng(value.results[0].geometry.location.lat,value.results[0].geometry.location.lng)  ;
        init['country'] = _country ;
        init['vicinity'] = value.results[0].vicinity ;
        BlocProvider.of(_context).mapBloc.setLocation(init) ;
      });
      _placeMark = value.results[0] ;
    });
    setState(() {
      _center = LatLng(_currentLocation.latitude, _currentLocation.longitude);
      _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:_center, zoom: _cameraZoom)));
      _markers.clear() ;
      _markers.add(
          Marker(
            markerId: MarkerId('marking location'),
            position: _center,
          )
      ) ;
    });
  }

  void _onMapCreated(controller){
    _mapController = controller ;
    if(_center == LatLng(0,0)) {
      getUserLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context ;
    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: BlocProvider.of(context).mapBloc.mapControl,
          builder: (context, snapshot){
            if(snapshot.hasData){
              _markers = snapshot.data['marker'] ;
              _center = snapshot.data['center'] ;
              BlocProvider.of(context).mapBloc.setLocation(snapshot.data) ;
              _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(_center.latitude, _center.longitude),
                zoom: _cameraZoom,
              )));
            }
            return GoogleMap(
              markers: _markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _cameraZoom,
              ),
            ) ;
          }
        ),

        InkWell(
          child: Container(),
          onTap: (){
            if(_center != LatLng(0,0)){
              print('tap') ;
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return FullScreenMapApi(_markers, _center, _placeMark, _country) ;
                  }
              ));
            }
          },
        ),

      ],
    ) ;


  }

  @override
  void dispose() {
    super.dispose();
  }


}
