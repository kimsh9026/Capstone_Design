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
  String _searchAddr;
  static Widget _searchBar ;
  List<PlacesSearchResult> _placeList  = List<PlacesSearchResult>();
  double _searchingListHeight = 0 ;

  @override
  void initState() {
    super.initState();
    _searchBar = TextField(
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

//  Widget _searchBar(){
//    return TextField(
//        decoration: InputDecoration(
//            hintText: 'Enter Address',
//            border: InputBorder.none,
//            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
//            suffixIcon: IconButton(
//              icon: Icon(Icons.search),
//              onPressed: searchAndNavigate,
//              iconSize: 30.0,
//            )
//        ),
//        onChanged: (val) {
//          setState(() {
//            _searchAddr = val;
//          });
//        }
//    );
//  }

  void _placeSelected(PlacesSearchResult result){

    BlocProvider.of(context).mapBloc.setSimpleAddress(result.name);
    BlocProvider.of(context).mapBloc.setDetailAddress(result.vicinity) ;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(result.geometry.location.lat, result.geometry.location.lng),
        zoom: 16.0
    )));
    mapController.addMarker(
        MarkerOptions(
          position: LatLng(result.geometry.location.lat, result.geometry.location.lng),
        )
    ) ;
    setState(() {
      isSearching = false ;
      _searchingListHeight = 0 ;
    });
  }

  Widget _expandingSearchBar(Widget child){
    return Container(
      child: Column(
        children: <Widget>[
          child,
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

  Widget _searchBarAnimation(){
    return AnimatedCrossFade(
      firstChild: _searchBar,
      secondChild: _expandingSearchBar(_searchBar),
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            top: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white
              ),
              child: _expandingSearchBar(_searchBar),
            )
        )
      ],
    );


  }

  void _onMapCreated(controller){
    mapController = controller ;
    getUserLocation() ;
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



  void searchAndNavigate() {

    setState(() {
      isLoading = true ;
      print('loading') ;
    });

    _placeList = List<PlacesSearchResult>() ;

    _places.searchByText(_searchAddr).then((result) {
      result.results.forEach((f) { print('hi ${f.name}'); setState(() {
        _placeList.add(f) ;
      });
      isLoading = false ;
      });
    }) ;
    
//    Geolocator().placemarkFromAddress(_searchAddr).then((result) {
//      print(result[0].position.toString()) ;
//      _places.searchNearbyWithRadius(Location(result[0].position.latitude, result[0].position.longitude), 100)
//          .then((value){
//            value.results.forEach((f) {print(f.name); }) ;
//        BlocProvider.of(context).mapBloc.setSimpleAddress(value.results[1].name);
//        BlocProvider.of(context).mapBloc.setDetailAddress(value.results[1].vicinity) ;
//      });
//
//      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//          target:
//          LatLng(result[0].position.latitude, result[0].position.longitude),
//          zoom: 16.0
//      )));
//      mapController.addMarker(
//          MarkerOptions(
//            position: LatLng(result[0].position.latitude, result[0].position.longitude),
//          )
//      ) ;
//    });

    setState(() {
      isSearching = true ;
      _searchingListHeight = 300 ;
    });

  }

}
