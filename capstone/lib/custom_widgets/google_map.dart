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
  bool isLoading = true;
  String searchAddr;

  @override
  void initState() {
    super.initState();
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
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white
              ),
              child: TextField(
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
                      searchAddr = val;
                    });
                  }
              ),
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
    
    _places.searchByText(searchAddr).then((result) {
      result.results.forEach((f) => print('hi ${f.name}'));
    }) ;
    
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      print(result[0].position.toString()) ;
      _places.searchNearbyWithRadius(Location(result[0].position.latitude, result[0].position.longitude), 10)
          .then((value){
            value.results.forEach((f) => print(f.name)) ;
        BlocProvider.of(context).mapBloc.setSimpleAddress(value.results[1].name);
        BlocProvider.of(context).mapBloc.setDetailAddress(value.results[1].vicinity) ;
      });

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 16.0
      )));
      mapController.addMarker(
          MarkerOptions(
            position: LatLng(result[0].position.latitude, result[0].position.longitude),
          )
      ) ;
    });
  }

}
