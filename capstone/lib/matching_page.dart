import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:flutter/material.dart';
//import 'package:capstone/test/chat_room_info.dart' ;
import 'package:capstone/bottom_navigation.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

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
  GoogleMapController mapController;
  bool isLoading = false;


  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      print(lat);
      print(lng);
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Trabuddying"),
          actions: <Widget>[
            isLoading
                ? IconButton(
              icon: Icon(Icons.timer),
              onPressed: () {},
            )
                : IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                refresh();
              },
            ),
          ],
        ),

        body: GoogleMap(
          onMapCreated: _onMapCreated,
          options: GoogleMapOptions(
            myLocationEnabled: true,
            cameraPosition: const CameraPosition(target: LatLng(0.0, 0.0))
          ),
        ),
      ),
    );
  }
}