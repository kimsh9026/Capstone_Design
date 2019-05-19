import 'package:capstone/bloc_codes/bloc_provider.dart';
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

  GoogleMapController mapController;
  Position _currentLocation ;
  LatLng _center = LatLng(0,0) ;
  bool isLoading = false;
  bool isSearching = false ;
  String _searchAddr = '';
  List<PlacesSearchResult> _placeList  = List<PlacesSearchResult>();
  double _searchingListHeight = 0 ;
  BuildContext _context ;
//  TextEditingController _textEditingController = TextEditingController() ;

  @override
  void initState() {
    super.initState();
  }

  Widget _searchBar(){
    return TextField(
//        controller: _textEditingController,
        decoration: InputDecoration(
            hintText: 'Enter Address',
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: searchAndNavigate,
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

  void _goToCenter(){
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(_center.latitude, _center.longitude),
        zoom: 16.0
    )));
  }

  void _mapNavigate(double lat, double lng){
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(lat, lng),
        zoom: 16.0
    )));
    mapController.clearMarkers() ;
    mapController.addMarker(
        MarkerOptions(
          position: LatLng(lat, lng),
        )
    ) ;
  }

  void _placeSelected(PlacesSearchResult result){
    BlocProvider.of(context).mapBloc.setSimpleAddress(result.name);
    BlocProvider.of(context).mapBloc.setDetailAddress(result.vicinity) ;
    _center = LatLng(result.geometry.location.lat, result.geometry.location.lng) ;
    _mapNavigate(result.geometry.location.lat, result.geometry.location.lng) ;
    setState(() {
      isSearching = false ;
      _searchingListHeight = 0 ;
    });
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
                child: Text('검색 결과가 없습니다.'),
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

  @override
  Widget build(BuildContext context) {
    _context = context ;
    return Stack(
      children: <Widget>[
        GoogleMap(
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

  void _onMapCreated(controller){
    mapController = controller ;
    getUserLocation() ;
    BlocProvider.of(context).mapBloc.mapOff.listen((value){
      if(value){
        _goToCenter() ;
        if(isSearching){
          isSearching = false ;
          _searchingListHeight = 0 ;
        }
        FocusScope.of(context).requestFocus(FocusNode()) ;
      }
    }) ;
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    _currentLocation = await locateUser();
    _places.searchNearbyWithRadius(Location(_currentLocation.latitude, _currentLocation.longitude), 2500)
    .then((value){
      value.results.forEach((f) => print(f.name)) ;
      BlocProvider.of(context).mapBloc.setSimpleAddress(value.results[0].name);
      BlocProvider.of(context).mapBloc.setDetailAddress(value.results[0].vicinity) ;
    });
    setState(() {
      _center = LatLng(_currentLocation.latitude, _currentLocation.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:_center, zoom: 16.0)));
      mapController.addMarker(
        MarkerOptions(
          position: _center,
        )
      ) ;
    });
  }


// 만약 '밥' 이라고 검색하면 결과가 너무 많이 나와서 infinite loading.
  void searchAndNavigate() {
    if(_searchAddr != ''){
      FocusScope.of(context).requestFocus(FocusNode()) ;
      setState(() {
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
      Geolocator().placemarkFromAddress(_searchAddr).then((result) {
        _places.searchNearbyWithRadius(Location(result[0].position.latitude, result[0].position.longitude), 100)
            .then((value){
          value.results.forEach((f) {print(f.name); setState(() {
            _placeList.add(f) ;
          });
          isLoading = false ;
          }) ;
        });
      });

      setState(() {
        isSearching = true ;
        _searchingListHeight = 300 ;
      });

    }
  }
}
