import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:flutter/material.dart';
//import 'package:capstone/test/chat_room_info.dart' ;
import 'package:capstone/bottom_navigation.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MatchingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MatchingPage Build") ;
    return MapApi();
  }
}

class MapApi extends StatefulWidget {
  @override
  State<MapApi> createState() => MapApiState();
}

class MapApiState extends State<MapApi> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  LatLng _lastMapPosition = _center;

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Trabuddying'),
          backgroundColor: Colors.white,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}