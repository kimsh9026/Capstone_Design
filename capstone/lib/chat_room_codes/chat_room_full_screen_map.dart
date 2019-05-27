import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCWiFLiauFZv-cMSqXX_f4mRTn9rYd6ssw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class ChatRoomFullScreenMap extends StatefulWidget{
  Set<Marker> _markers = Set<Marker>() ;
  LatLng _center = LatLng(0,0) ;

  ChatRoomFullScreenMap(this._markers, this._center) ;

  @override
  State<ChatRoomFullScreenMap> createState() => ChatRoomFullScreenMapState() ;
}

class ChatRoomFullScreenMapState extends State<ChatRoomFullScreenMap> {

  Set<Marker> _markers = Set<Marker>() ;
  LatLng _center = LatLng(0,0) ;
  double _cameraZoom ;
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _markers = widget._markers ;
    _center = widget._center ;
    _cameraZoom = 16 ;
  }

  void _onMapCreated(controller) {
    _mapController = controller ;
  }

  void _goToMeetingLocation(){
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:_center,
        zoom: _cameraZoom
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 1,
        elevation: 0.1,
        bottomOpacity: 1,
        title: Text(
          '위치 찾기',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(47, 146, 217, 0.9),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            markers: _markers,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: _cameraZoom,
            ),
          ),
          RaisedButton(

            color: Colors.white,
            child: Icon(Icons.location_on, color: Colors.grey,),
            onPressed: _goToMeetingLocation,
          )
        ],
      )
    ) ;
  }
}