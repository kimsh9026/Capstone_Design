
import 'package:capstone/matching_page_codes/color_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchingScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MatchingScreenState() ;
  }
}

class MatchingScreenState extends State<MatchingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(215, 238, 247, 0.5),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text('Trabuddying', style: Theme.of(context).textTheme.title,),
            ),
          ),
          Expanded(
            flex: 8,
            child:  Center(
              child: ColorLoader3(radius: 60, dotRadius: 15,) ,
            )
          )
        ],
      )
    );
  }


}