

import 'package:capstone/chat_room_codes/chat_room_full_screen_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCWiFLiauFZv-cMSqXX_f4mRTn9rYd6ssw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class ChatRoomMapApi extends StatefulWidget{

  LatLng _center ;

  ChatRoomMapApi(this._center) ;

  @override
  State<ChatRoomMapApi> createState() => ChatRoomMapApiState() ;
}

class ChatRoomMapApiState extends State<ChatRoomMapApi>{
  LatLng _center ;
  Set<Marker> _markers ;
  GoogleMapController _mapController;
  double _cameraZoom ;

  @override
  void initState() {
    super.initState();
    _center = widget._center ;
    _markers = Set<Marker>() ;
    _markers.clear() ;
    _markers.add(
      Marker(
        markerId: MarkerId('meeting location'),
        position: _center,
      )
    ) ;
    _cameraZoom = 16 ;
  }

  void _onMapCreated(controller){
    _mapController = controller ;
//    if(_center == LatLng(0,0)) {
//      getUserLocation();
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: _cameraZoom,
          ),
        ),
        InkWell(
          child: Container(),
          onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return ChatRoomFullScreenMap(_markers, _center) ;
                  }
              ));
          },
        ),

      ],
    ) ;
  }
}