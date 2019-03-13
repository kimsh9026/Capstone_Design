import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart' ;
import 'package:capstone/ListBlock.dart' ;

void main() => runApp(Gradient()) ;

class Gradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient Pracitce',
      theme: new ThemeData(brightness: Brightness.light),
      home: Gradient_p(),
    );
  }
}

class Gradient_p extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new Gradient_pState() ;
}


class Gradient_pState extends State<Gradient_p> {

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [const Color(0xFF5032B6),
                const Color(0xffd545d3),
                    const Color(0xEE)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter
              )
            )
          )
        ],
      ),


    );
  }

}