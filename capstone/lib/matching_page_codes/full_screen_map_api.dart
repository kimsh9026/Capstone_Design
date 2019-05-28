
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCWiFLiauFZv-cMSqXX_f4mRTn9rYd6ssw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class FullScreenMapApi extends StatefulWidget{
  Set<Marker> _markers = Set<Marker>() ;
  LatLng _center = LatLng(0,0) ;
  PlacesSearchResult _placeMark ;
  String _country ;

  FullScreenMapApi(this._markers, this._center, this._placeMark, this._country) ;

  @override
  State<FullScreenMapApi> createState() => FullScreenMapApiState();
}

class FullScreenMapApiState extends State<FullScreenMapApi>{
  Set<Marker> _markers = Set<Marker>() ;
  LatLng _center = LatLng(0,0) ;
  GoogleMapController _mapController;
  String _searchAddr = '';
  List<PlacesSearchResult> _placeList  = List<PlacesSearchResult>();
  double _searchingListHeight = 0 ;
  bool isLoading = false;
  bool isSearching = false ;
  String _infoText ;
  String _country ;
  double _cameraZoom ;
  BuildContext _context ;
  Map<String, dynamic> _info ;
  TextEditingController _textEditingController ;

  @override
  void initState() {
    super.initState();
    _markers = widget._markers ;
    _center = widget._center ;
    _country = widget._country ;
    _cameraZoom = 16 ;
    _info = Map<String, dynamic>() ;
    _textEditingController = TextEditingController() ;
    _info['marker'] = _markers ;
    _info['center'] = _center ;
    _info['country'] = _country ;
    print('init country : ${_country}') ;
    _info['vicinity'] = widget._placeMark.vicinity;
    _info['name'] = widget._placeMark.name ;
  }

  void _onMapCreated(controller){
    _mapController = controller ;
  }

  void search() {
    if(_searchAddr != ''){
      FocusScope.of(_context).detach() ;
      _infoText = '' ;
      isLoading = true ;
      print('loading') ;
      _placeList = List<PlacesSearchResult>() ;

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
        },
        controller: _textEditingController,
    );
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

  void _placeSelected(PlacesSearchResult result){
    Geolocator().placemarkFromCoordinates(result.geometry.location.lat, result.geometry.location.lng)
        .then((result) {
      _country = result[0].country ;
      _info['country'] = _country ;
    });
    _textEditingController.text = result.name ;
    _center = LatLng(result.geometry.location.lat, result.geometry.location.lng) ;
    _mapNavigate(_center.latitude, _center.longitude) ;
    _info['marker'] = _markers ;
    _info['center'] = _center ;
    _info['country'] = _country ;
    _info['vicinity'] = result.vicinity ;
    _info['name'] = result.name ;
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

@override
  Widget build(BuildContext context) {
    _context = context ;
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
        actions: <Widget>[
          FlatButton(
            child: Text('확인', style: TextStyle(color: Color.fromRGBO(47, 146, 217, 0.9),),),
            onPressed: () {
              BlocProvider.of(context).mapBloc.setMapControl(_info) ;
              Navigator.pop(context) ;
              },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _markers,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: _cameraZoom,
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
      ),
    ) ;
  }

  @override
  void dispose() {
    _textEditingController.clear() ;
    super.dispose();
  }



}