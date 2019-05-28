import 'dart:async';

import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/matching_page_codes/matching_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCWiFLiauFZv-cMSqXX_f4mRTn9rYd6ssw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class MapApi extends StatefulWidget {
  @override
  State<MapApi> createState() => MapApiState();
}

class MapApiState extends State<MapApi> {

  GoogleMapController _mapController;
  Position _currentLocation ;
  LatLng _center = LatLng(0,0) ;
  bool isLoading = false;
  bool isSearching = false ;
  String _searchAddr = '';
  List<PlacesSearchResult> _placeList  = List<PlacesSearchResult>();
  double _searchingListHeight = 0 ;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  double _circleRadius = 400 ;
  double _cameraZoom = 16 ;
  BuildContext _context ;
  StreamSubscription<bool> _mapOffSubscription ;
  StreamSubscription<double> _radiusChangeSubscription;
  String _infoText ;
  MatchingInfo _matchingInfo ;

  @override
  void initState() {
    super.initState();
    _mapController = null ;
    _currentLocation = null ;
    _center = LatLng(0,0) ;
    isLoading = false ;
    isSearching = false ;
    _searchAddr = '';
    _placeList  = List<PlacesSearchResult>();
    _searchingListHeight = 0 ;
    _markers = Set<Marker>();
    _circles = Set<Circle>();
    _circleRadius = 400 ;
    _cameraZoom = 16 ;
    _context = null ;
    _infoText = '검색 결과가 없습니다.' ;
    _markers.add(Marker(markerId: MarkerId('default'))) ;
    _matchingInfo = MatchingInfo() ;
  }

  void _goToCenter(){
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_center.latitude, _center.longitude),
        zoom: _cameraZoom,
    )));
  }

  void _mapNavigate(double lat, double lng){
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(lat, lng),
        zoom: _cameraZoom
    )));
    _markers.clear() ;
    _markers.add(
      Marker(
        markerId: MarkerId('marking location'),
        position: LatLng(lat, lng),
      )
    ) ;
  }


// 만약 '밥' 이라고 검색하면 결과가 너무 많이 나와서 infinite loading.
  void search() {
    if(_searchAddr != ''){
      FocusScope.of(_context).detach() ;
      setState(() {
        _infoText = '' ;
        isLoading = true ;
        print('loading') ;
      });

      _placeList = List<PlacesSearchResult>() ;

// 이름기반 (이름이 유사한 순으로 리스트가 나옴)
//    _places.searchByText(_searchAddr).then((result) {
//      result.results.forEach((f) { print('hi ${f.name}'); setState(() {
//        _placeList.add(f) ;
//      });
//      isLoading = false ;
//      });
//    }) ;
//

// 장소기반 (상세주소가 자세히 나옴)
      Geolocator().placemarkFromAddress(_searchAddr)
          .catchError((value) => null)
          .then((result) {
            if(result != null){
              if(result.length == 0 ) {_infoText = '검색 결과가 없습니다.' ;}
              else {
                _places.searchNearbyWithRadius(
                    Location(result[0].position.latitude, result[0].position.longitude), 100
                )
                    .then((value) {
                  value.results.forEach((f) { print(f.name);
                    setState(() {
                      _placeList.add(f);
                    });
                  });
                });
              }
              isLoading = false;
            }
            else{
              Future.delayed(Duration(seconds: 4),(){
                _infoText = '검색량이 너무 많습니다. 자세히 검색해주세요.' ;
                setState(() {
                  isLoading = false ;
                });
              }) ;
              _places.searchByText(_searchAddr)
              .then((result) {
                  if(result.results.length == 0 ) {_infoText = '검색 결과가 없습니다.' ;}
                  else{
                    result.results.forEach((f) { print('hi ${f.name}'); setState(() {
                      _placeList.add(f) ;
                    });
                    });
                  }
                  isLoading = false ;
              }) ;
            }
      });
      setState(() {
        isSearching = true ;
        _searchingListHeight = 300 ;
      });

    }
  }

  void _placeSelected(PlacesSearchResult result){
    Geolocator().placemarkFromCoordinates(result.geometry.location.lat, result.geometry.location.lng)
    .then((result) {
      _matchingInfo.country = result[0].country ;
    });
    _matchingInfo.placesSearchResult = result ;
    BlocProvider.of(_context).mapBloc.setSearchResponse(_matchingInfo);
    BlocProvider.of(_context).mapBloc.setDetailAddress(result.vicinity) ;
    _center = LatLng(result.geometry.location.lat, result.geometry.location.lng) ;
    _mapNavigate(_center.latitude, _center.longitude) ;
    setState(() {
      isSearching = false ;
      _searchingListHeight = 0 ;
    });
  }

  Widget _searchBar(){
    return TextField(
        decoration: InputDecoration(
            hintText: '주소를 입력해주세요',
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: search,
              iconSize: 30.0,
            )
        ),
        onChanged: (val) {
          setState(() {
            _searchAddr = val ;
          });
        }
    );
  }

  Widget _expandingSearchBar(){
    return Container(
      child: Column(
        children: <Widget>[
          _searchBar(),
          AnimatedContainer(
              curve: Curves.linear,
              duration: Duration(milliseconds: 100),
              height: _searchingListHeight,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black, width: 0.1)
                  )
              ),
              child: !isSearching ?
              Container() :
              (isLoading ?
              Center(
                child: CircularProgressIndicator(),
              ) :
              (_placeList.length == 0 ?
              Center(
                child: Text(_infoText),
              ) :
              Scrollbar(
                  child:  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _placeList.length,
                      itemBuilder: (context, int,
                          {
                            shrinkWrap: true,
                          }) {
                        return ListTile(
                          title: Text(_placeList[int].name),
                          onTap: () => _placeSelected(_placeList[int]),
                        );
                      }
                  )
              )
              )
              )
          ),
        ],
      ),
    ) ;
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    _currentLocation = await locateUser();
    _places.searchNearbyWithRadius(Location(_currentLocation.latitude, _currentLocation.longitude), 2500)
        .then((value){
      Geolocator().placemarkFromCoordinates(value.results[0].geometry.location.lat, value.results[0].geometry.location.lng)
          .then((result) {
        _matchingInfo.country = result[0].country ;
      });
      _matchingInfo.placesSearchResult = value.results[0] ;
      BlocProvider.of(_context).mapBloc.setSearchResponse(_matchingInfo);
      BlocProvider.of(_context).mapBloc.setDetailAddress(value.results[0].vicinity) ;
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

  void _removeBoundary(){
    _circles.clear() ;
  }
  void _showBoundary(){
    _goToCenter() ;
    _circles.clear() ;
    _circles.add(Circle(
      strokeColor: Color.fromRGBO(47, 146, 217, 0.9),
      fillColor: Color.fromRGBO(30, 100, 200, 0.2),
      circleId: CircleId('radius'),
      center: _center,
      radius: _circleRadius,
    ));
  }

  void _onMapCreated(controller){
    print('create Map') ;
    _mapController = controller ;
    getUserLocation() ;
    _mapOffSubscription = BlocProvider.of(_context).mapBloc.mapOff.listen((value){
      if(value){
        if(isSearching){
          print('isSearching?') ;
          isSearching = false ;
          _searchingListHeight = 0 ;
          FocusScope.of(_context).detach() ;
        }
        _showBoundary() ;
      }
      else{
        _removeBoundary() ;
      }
    }) ;
    _radiusChangeSubscription = BlocProvider.of(_context).mapBloc.radius.listen((radius){
      _circleRadius = radius ;
      _cameraZoom = radius <= 200 ? 17 : (
          radius <= 400 ? 16 : (
              radius <= 800 ? 15 : 14
          )) ;
      _showBoundary() ;
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    _context = context ;
    return Stack(
      children: <Widget>[
        GoogleMap(
//          myLocationEnabled: true,
//          trackCameraPosition: true,
        circles: _circles,
        markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
        ),
        Positioned(
            top: 50.0,
            right: 30.0,
            left: 30.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white
              ),
              child: _expandingSearchBar(),
            )
        )
      ],
    );
  }

  @override
  void dispose() {
    _mapOffSubscription.cancel() ;
    _radiusChangeSubscription.cancel() ;
    super.dispose();
  }


}
