import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/matching_page_codes/map_api.dart';
import 'package:capstone/matching_page_codes/matching_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart' ;

class MatchingPageUI extends StatefulWidget {
  @override
  _MatchingPageUIState createState() => _MatchingPageUIState() ;
}

class _MatchingPageUIState extends State<MatchingPageUI> with TickerProviderStateMixin {
  AnimationController step1 ;
  AnimationController step2 ;
  AnimationController step3 ;
  AnimationController step4 ;
  Animation<Offset> offset1 ;
  Animation<Offset> offset2 ;
  Animation<Offset> offset3 ;
  Animation<Offset> offset4 ;
  Animation<double> heightOffset ;
  String _stepMessage1 = '원하는 장소를 검색을 통해 찾으세요.' ;
  String _stepMessage2 = '설정한 장소로부터 친구를 찾을 반경을 정해주세요' ;
  String _stepMessage3 = '사람들을 만나 무엇을 하고 싶나요?' ;
  String _stepMessage4 = '최대 인원을 설정해주세요' ;
  String _stepMessage5 = '매칭을 시작하려면 완료를 눌러주세요' ;
  double _width = 350 ;
  double _fixedHeight = 80 ;
  double _changingHeight2 = 80 ;
  double _changingHeight3 = 80 ;
  double _changingHeight4 = 80 ;
  double _messageBoxHeight = 50 ;
  int _step = 1 ;
  String _locationName = ' ' ;
  String _locationNameDetail = ' ' ;
  double _sliderValue = 0.4 ;
  String _pressedButtonName = '식사' ;
  int _numberOfPeople = 4;
  MatchingInfo _matchingInfo ;

  @override
  initState(){
    super.initState() ;
    _step = 1 ;
    _locationName = ' ' ;
    _locationNameDetail =  ' ' ;
    _sliderValue = 0.4 ;
    _pressedButtonName = '식사' ;
    _numberOfPeople = 4 ;
    _matchingInfo = MatchingInfo() ;

    step1 = AnimationController(vsync: this, duration: Duration(milliseconds: 200)) ;
    step2 = AnimationController(vsync: this, duration: Duration(milliseconds: 200)) ;
    step3 = AnimationController(vsync: this, duration: Duration(milliseconds: 200)) ;
    step4 = AnimationController(vsync: this, duration: Duration(milliseconds: 200)) ;
    offset1 = Tween<Offset> (begin: Offset(0.0, 4.9), end: Offset(0.0, 0.5)).animate(step1) ;
    offset2 = Tween<Offset> (begin: Offset(0.0, 4.9), end: Offset(0.0, 2.4)).animate(step2) ;
    offset3 = Tween<Offset> (begin: Offset(0.0, 4.9), end: Offset(0.0, 3.5)).animate(step3) ;
    offset4 = Tween<Offset> (begin: Offset(0.0, 4.9), end: Offset(0.0, 4.6)).animate(step4) ;
  }

  Widget build(BuildContext context){
   return Scaffold(
     backgroundColor: Color.fromRGBO(215, 238, 247, 0.9),
     body: _matchingBody(context),
   )  ;
  }

  Widget _stepContainer1(BuildContext context){
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('기준 장소', textAlign: TextAlign.left, style: TextStyle(color: Colors.blue, fontSize: 10),),
                Padding(padding: EdgeInsets.only(top: 3)),
                StreamBuilder(
                  stream: BlocProvider.of(context).mapBloc.searchResponse,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      _matchingInfo = snapshot.data ;
                    }
                    return Text(
                      snapshot.hasData ? snapshot.data.locationName : '현재 위치를 불러오는 중 입니다.',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 15)) ;
                  }
                ),
                StreamBuilder(
                    stream: BlocProvider.of(context).mapBloc.detailAddress,
                    builder: (context, snapshot){
                      return snapshot.hasData ?
                        Text(
                          snapshot.hasData ? snapshot.data : _locationNameDetail,
                          textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 11))
                          : Container() ;
                    }
                ),
              ],
            )
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Icon(Icons.location_on,color: Colors.orange,),
            )
          )
        ],
      )
    );
  }

  void _sliderOnChanged(double value){
    setState((){
      _sliderValue = value ;
      BlocProvider.of(context).mapBloc.setRadius(value*1000) ;
    }) ;
  }

  Widget _stepContainer2(){
    return _step <= 2 ?
      Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text('반경', textAlign: TextAlign.left, style: TextStyle(color: Colors.blue, fontSize: 12),),
                )
            ),
            Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text('${_sliderValue.toStringAsFixed(1)} km', style: TextStyle(color: Colors.blue, fontSize: 15),),
                    Slider(
                      min: 0.1,
                      max : 1.5,
                      value: _sliderValue,
                      onChanged: _sliderOnChanged,
                    )
                  ],
                )
            )
          ],
        )
    ) :
    Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  child: Text('반경', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 14),),
                )
            ),
            Expanded(
                flex: 5,
                child: Text('${_sliderValue.toStringAsFixed(1)} km', style: TextStyle(color: Colors.black, fontSize: 14),),
            )
          ],
        )
    ) ;
  }

  Widget _purposeButton(String name){
    return
      _pressedButtonName == name ?
      RaisedButton(
        elevation: 0.3,
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(name),
        onPressed: () => setState((){}),
      ) :
      OutlineButton(
        color: Colors.white,
        textColor: Colors.grey,
        child: Text(name),
        onPressed: () => setState(() {_pressedButtonName = name;}),
      ) ;
  }

  Widget _stepContainer3(){
    return _step <= 3 ?
    Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 15, top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text('목적', textAlign: TextAlign.left, style: TextStyle(color: Colors.blue, fontSize: 12),),
                )
            ),
            Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      flex : 1,
                      child: _purposeButton('식사'),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      flex : 1,
                      child: _purposeButton('동행'),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      flex : 1,
                      child: _purposeButton('교통'),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      flex : 1,
                      child: _purposeButton('숙박'),
                    ),
                    Padding(padding: EdgeInsets.all(5)),

                  ],
                )
            )
          ],
        )
    ) :
    Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  child: Text('목적', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 14),),
                )
            ),
            Expanded(
              flex: 5,
              child: Text('${_pressedButtonName}', style: TextStyle(color: Colors.black, fontSize: 14),),
            )
          ],
        )
    ) ;
  }

  Widget _stepContainer4(){
    return _step <= 4 ?
    Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 15, top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text('인원', textAlign: TextAlign.left, style: TextStyle(color: Colors.blue, fontSize: 12),),
                )
            ),
            Expanded(
                flex: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: NumberPicker.integer(
                        infiniteLoop: true,
                        itemExtent: 22,
                        listViewWidth: 20,
                        initialValue: _numberOfPeople,
                        minValue: 2,
                        maxValue: 5,
                        onChanged: (value) => setState(() => _numberOfPeople = value),
                      ),
                    ),
                    Text('명'),
                  ],
                )
            )
          ],
        )
    ) :
    Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  child: Text('인원', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 14),),
                )
            ),
            Expanded(
              flex: 5,
              child: Text('${_numberOfPeople}명', style: TextStyle(color: Colors.black, fontSize: 14),),
            )
          ],
        )
    ) ;
  }

  Widget _fixedBox(Animation<Offset> offset, int index, BuildContext context){
    return Container(
        height: double.infinity,
        width: double.infinity,
//        color: Colors.blue,
        child: Column(
          children: <Widget>[
            SlideTransition(
              position: offset,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 500),
                  height: _fixedHeight,
                  width: _width,
                  child: InkWell(
                    child: _stepContainer1(context),
                    onTap: () {_step = index ;  _stepController() ;},
                  ),
                ),
              ),
            ),
          ],
        ),
      ) ;
  }

  Widget _changingBox(Animation<Offset> offset, int index){
    return
      Container(
        height: double.infinity,
        width: double.infinity,
//        color: Colors.blue,
        child: Column(
          children: <Widget>[
            SlideTransition(
              position: offset,
              child: Card(
//                color: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  width: _width,
                  height: index == 2 ? _changingHeight2 : (index == 3 ? _changingHeight3 : _changingHeight4),
//                  color: Colors.black,
                  duration: Duration(milliseconds: 500),
                  child: InkWell(
                    child: index == 2 ? _stepContainer2() : (index == 3 ? _stepContainer3() : _stepContainer4()),
                    onTap: () {_step = index ;  _stepController() ;},
                  ),
                ),
              ),
            ),
          ],
        ),
      ) ;
  }

  void animateContainer(int index, bool isAnimated){
    setState(
        (){
          index == 2 ? (_changingHeight2 = !isAnimated ? _fixedHeight : 50) :
          (index == 3 ? (_changingHeight3 = !isAnimated ? _fixedHeight : 50)
          : (_changingHeight4 = !isAnimated ? _fixedHeight : 50));
        }
    ) ;
  }

  void _stepController(){
    if(_step == 1){
      BlocProvider.of(context).mapBloc.setMapOff(false) ;
      animateContainer(2, false) ;
      animateContainer(3, false) ;
      animateContainer(4, false) ;
      step1.reverse() ;
      step2.reverse() ;
      step3.reverse() ;
      step4.reverse() ;

    }
    else if(_step == 2){
      BlocProvider.of(context).mapBloc.setMapOff(true) ;
      animateContainer(2, false) ;
      animateContainer(3, false) ;
      animateContainer(4, false) ;
      step1.forward() ;
      step2.reverse() ;
      step3.reverse() ;
      step4.reverse() ;

    }
    else if(_step == 3){
      animateContainer(2, true) ;
      animateContainer(3, false) ;
      animateContainer(4, false) ;
      step1.forward() ;
      step2.forward() ;
      step3.reverse() ;
      step4.reverse() ;

    }
    else if(_step == 4){
      animateContainer(2, true) ;
      animateContainer(3, true) ;
      animateContainer(4, false) ;
      step1.forward() ;
      step2.forward() ;
      step3.forward() ;
      step4.reverse() ;
    }
    else if(_step == 5){
      animateContainer(2, true) ;
      animateContainer(3, true) ;
      animateContainer(4, true) ;
      step1.forward() ;
      step2.forward() ;
      step3.forward() ;
      step4.forward() ;
      _matchingInfo.purpose = _pressedButtonName ;
      _matchingInfo.boundary = _sliderValue ;
      _matchingInfo.number = _numberOfPeople ;
    }
    else{
      print(_matchingInfo.location.toString()) ;
      print(_matchingInfo.country) ;
      print(_matchingInfo.locationName) ;
      print(_matchingInfo.boundary) ;
      print(_matchingInfo.purpose) ;
      print(_matchingInfo.number) ;
      FirestoreProvider().startMatching(_matchingInfo) ;
      BlocProvider.of(context).bottomBarBloc.setMatchingStart(true) ;
    }


  }

  Widget _messageBox(){
    return InkWell(
      child: Container(
        color: Colors.lightBlue,
        height: _messageBoxHeight,
        width: double.infinity,
        child: Container(
          child: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10)),
              Expanded(
                  flex: 5,
                  child: Text(
                    _step == 1 ? _stepMessage1 :
                    (_step == 2 ? _stepMessage2 : (_step == 3 ? _stepMessage3 :
                    (_step == 4 ? _stepMessage4 : _stepMessage5))),
                    style: TextStyle(color: Colors.white),
                  )
              ),
              Expanded(
                flex: 1,
                child: Text(_step > 4 ? '완료' : '다음', style: TextStyle(color: Colors.white)),
              )
            ],
          )
        ),
      ),
      onTap: (){
        _step++ ;
        _stepController() ;
      }
    ) ;
  }

  Widget _matchingBody(BuildContext context){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Stack(
            children: <Widget>[
              MapApi(),
              _step > 1 ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromRGBO(255, 255, 255, 0.1),
              ):Container(),
              _changingBox(offset4, 4),
              _changingBox(offset3, 3),
              _changingBox(offset2, 2),
              _fixedBox(offset1, 1, context),
            ],
          )
        ),
        Expanded(
          flex: 1,
          child: _messageBox(),
        )
      ],
    );
//          _messageBox(),



  }


}