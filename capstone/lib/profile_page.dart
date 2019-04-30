import 'package:flutter/material.dart';
import 'package:capstone/custom_widgets/custom_expansion_panel.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("Profile Build") ;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color:Color.fromRGBO(61, 174, 218, 1),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text('Profile', textAlign : TextAlign.center, style : TextStyle(color: Color.fromRGBO(61, 174, 218, 1))),
        centerTitle: true,
        actions:
        <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color:Color.fromRGBO(61,174,218,1)),

          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:Alignment.topCenter,
                  end:Alignment.bottomCenter,

                  stops:[0.0, 0.18],
                  colors: [
                    Color.fromRGBO(61,174,218,1),
                    Colors.white,
                  ]
                )
              ),

              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width:160,
                        height:160,
                        child: Stack(
                          children:<Widget>[
                            Container(
                              width:160,
                              height:160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              )
                            ),
                            Container(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(61, 174, 218, 1),
                                  ),
                                  child: IconButton(
                                    icon:Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: ()=> print('hello!'),
                                  )
                                )
                            ),

                            Container(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(61, 174, 218, 1),
                                    ),
                                    child: IconButton(
                                      icon:Icon(Icons.message),
                                      color: Colors.white,
                                      onPressed: ()=> print('hello!'),
                                    )
                                )
                            ),


                          ]
                        ),
                      )
                    ]
                  )
                )
              ),
            ),
          )
        ]
      )
    );
  }
}