import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangingBox extends StatefulWidget{

  _ChangingBoxState _state ;
  Function() get reverse => _ChangingBoxState().reverse ;
  Function() get forward => _state.forward ;
  @override
  _ChangingBoxState createState() {
    _state = _ChangingBoxState() ;
    return _state ;
  }
}

class _ChangingBoxState extends State<ChangingBox> with SingleTickerProviderStateMixin{

  AnimationController _controller ;
  Animation<Offset> _offset ;
  double _width = 350 ;
  double _height = 70 ;

  initState(){
    super.initState() ;
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200)) ;
    _offset = Tween<Offset> (begin: Offset(0.0, 4.8), end: Offset(0.0, 0.03)).animate(_controller) ;
  }


  void reverse() {
    _controller.reverse() ;
    animateContainer(false) ;
  }

  void forward() {
    _controller.forward() ;
    animateContainer(true) ;
  }

  void animateContainer(bool isAnimated){
    setState((){
      _height = isAnimated ? 50 : 70 ;
    }) ;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
//        color: Colors.blue,
      child: Column(
        children: <Widget>[
          SlideTransition(
            position: _offset,
            child: Card(
              color: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                width: _width,
                height: _height,
//                  color: Colors.black,
                duration: Duration(milliseconds: 500),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    ) ;
  }

}