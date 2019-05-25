
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/main.dart';
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
  void initState() {
    FirestoreProvider().matchingStream().listen((snapshot){
      print(snapshot.documents.length ) ;
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreProvider().matchingStream(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          print(!snapshot.hasData) ;
          return Container(child: Text('lodaing')) ;
        }
        else if(snapshot.data.documents.length == 0){
          MyApp.isMatching = false ;
          BlocProvider.of(context).bottomBarBloc.setBottomBarPressed(1) ;
          return Container(child: Text('lodaing')) ;
        }
        return Container(
            color: Color.fromRGBO(215, 238, 247, 0.5),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text('매칭중입니다', style: Theme.of(context).textTheme.title,),
                  ),
                ),
                Expanded(
                    flex: 6,
                    child:  Container(
                      alignment: Alignment.bottomCenter,
                      child: ColorLoader3(radius: 60, dotRadius: 15,) ,
                    )
                ),
                Expanded(
                  flex: 3,
                  child: FlatButton(
                    onPressed: (){
                      FirestoreProvider().exitMatching() ;
                    },
                    child: Text('매칭 취소', style: TextStyle(color: Color.fromRGBO(47, 146, 217, 0.9)),),
                  )
                )
              ],
            )
        ) ;
      }
    ) ;
  }


}