import 'package:capstone/matching_page_codes/matching_page_ui.dart';
import 'package:flutter/material.dart';

class MatchingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MatchingPage Build") ;
    return MatchingPageUI();
  }
}

//class MapApi extends StatefulWidget {
//  @override
//  State<MapApi> createState() => MapApiState();
//}
//
//class MapApiState extends State<MapApi> {
//  final homeScaffoldKey = GlobalKey<ScaffoldState>();
//  GoogleMapController mapController;
//  List<PlacesSearchResult> places = [];
//  bool isLoading = false;
//  String errorMessage;
//  String searchAddr;
//  static const LatLng _center = const LatLng(45.521563, -122.677433);
//
//  @override
//  Widget build(BuildContext context) {
//    Widget expandedChild;
//    if (isLoading) {
//      expandedChild = Center(child: CircularProgressIndicator(value: null));
//    } else if (errorMessage != null) {
//      expandedChild = Center(
//        child: Text(errorMessage),
//      );
//    }
//
//    return GoogleMap(
//        onMapCreated: _onMapCreated,
//        initialCameraPosition: CameraPosition(
//          target: _center,
//          zoom: 11.0,
//        )
//    );
//
//
////      Scaffold(
////        key: homeScaffoldKey,
////        appBar: AppBar(
////          title: const Text("Trabuddying"),
////          actions: <Widget>[
////            isLoading
////                ? IconButton(
////              icon: Icon(Icons.timer),
////              onPressed: () {},
////            )
////                : IconButton(
////              icon: Icon(Icons.refresh),
////              onPressed: () {
////                refresh();
////              },
////            ),
////            IconButton(
////              icon: Icon(Icons.search),
////              onPressed: () {
////                _handlePressButton();
////              },
////            ),
////          ],
////        ),
////        body: Stack(
////            children: <Widget>[
////              GoogleMap(
////                  onMapCreated: _onMapCreated,
////                  initialCameraPosition: CameraPosition(
////                  target: _center,
////                  zoom: 11.0,
////                ),
////              ),
////              Positioned(
////                  top: 30.0,
////                  right: 15.0,
////                  left: 15.0,
////                  child: Container(
////                    height: 50.0,
////                    width: double.infinity,
////                    decoration: BoxDecoration(
////                        borderRadius: BorderRadius.circular(10.0),
////                        color: Colors.white
////                    ),
////                    child: TextField(
////                        decoration: InputDecoration(
////                            hintText: 'Enter Address',
////                            border: InputBorder.none,
////                            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
////                            suffixIcon: IconButton(
////                              icon: Icon(Icons.search),
////                              onPressed: searchandNavigate,
////                              iconSize: 30.0,
////                            )
////                        ),
////                        onChanged: (val) {
////                          setState(() {
////                            searchAddr = val;
////                          });
////                        }
////                    ),
////                  )
////              ),
////            ]
////        )
////    );
//  }
//
//  void searchandNavigate() {
//    Geolocator().placemarkFromAddress(searchAddr).then((result) {
//      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//          target:
//          LatLng(result[0].position.latitude, result[0].position.longitude),
//          zoom: 10.0
//      )));
//    });
//  }
//
//  void refresh() async {
//    final center = await getUserLocation();
//    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
//    getNearbyPlaces(center);
//  }
//
//  void _onMapCreated(GoogleMapController controller) async {
//    mapController = controller;
//    refresh();
//  }
//
//  Future<LatLng> getUserLocation() async {
//    var currentLocation;
//    final location = LocationManager.Location();
//    try {
//      currentLocation = await location.getLocation();
//      final lat = currentLocation.latitude;
//      final lng = currentLocation.longitude;
//      final center = LatLng(lat, lng);
//      return center;
//    } on Exception {
//      currentLocation = null;
//      return null;
//    }
//  }
//
//  void getNearbyPlaces(LatLng center) async {
//    setState(() {
//      this.isLoading = true;
//      this.errorMessage = null;
//    });
//
//    final location = Location(center.latitude, center.longitude);
//    final result = await _places.searchNearbyWithRadius(location, 2500);
//    setState(() {
//      this.isLoading = false;
//      if (result.status == "OK") {
//        this.places = result.results;
//        result.results.forEach((f) {
//          final markerOptions = MarkerOptions(
//              position:
//              LatLng(f.geometry.location.lat, f.geometry.location.lng),
//              infoWindowText: InfoWindowText("${f.name}", "${f.types?.first}"));
//          mapController.addMarker(markerOptions);
//        });
//      } else {
//        this.errorMessage = result.errorMessage;
//      }
//    });
//  }
//
//  void onError(PlacesAutocompleteResponse response) {
//    homeScaffoldKey.currentState.showSnackBar(
//      SnackBar(content: Text(response.errorMessage)),
//    );
//  }
//
//  Future<void> _handlePressButton() async {
//    try {
//      final center = await getUserLocation();
//      Prediction p = await PlacesAutocomplete.show(
//          context: context,
//          strictbounds: center == null ? false : true,
//          apiKey: kGoogleApiKey,
//          onError: onError,
//          mode: Mode.fullscreen,
//          language: "en",
//          location: center == null
//              ? null
//              : Location(center.latitude, center.longitude),
//          radius: center == null ? null : 10000);
//
//      // showDetailPlace(p.placeId);
//    } catch (e) {
//      return;
//    }
//  }
//}