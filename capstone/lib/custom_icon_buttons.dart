

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIconButtons extends StatefulWidget{
  @override
  _CustomIconButtonsState createState() => _CustomIconButtonsState() ;
}

class _CustomIconButtonsState extends State<CustomIconButtons> {

  Widget purposeIconButton(String path, String name, bool isActive, int index){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 60,
                child: FlatButton(
                    shape: CircleBorder(),
//                    onPressed: () => _clickedIndex = index,
                    padding: EdgeInsets.all(0.0),
                    child: Image.asset(path)
                )
            ),
            Text(
              name,
              style: TextStyle(
                color: !isActive ? Colors.grey : Colors.orange,
              ),
            ),
          ],
        )
    );
  }

  Widget purposeIconAnimation(String path, String activePath, String name, int index){
    return AnimatedCrossFade(
      firstChild: purposeIconButton(path, name, false, index),
      secondChild: purposeIconButton(activePath, name, true, index),
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
//      crossFadeState: _clickedIndex == index ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 200),
    ) ;
  }

  Widget purposeContainer(){
    return Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            purposeIconAnimation('Images/category_ui/buddy.png', 'Images/category_ui/buddy_active.png', '동행', 1),
            purposeIconAnimation('Images/category_ui/meal.png','Images/category_ui/meal_active.png', '식사', 2),
            purposeIconAnimation('Images/category_ui/stay.png', 'Images/category_ui/stay_active.png', '숙소', 3),
            purposeIconAnimation('Images/category_ui/tran.png','Images/category_ui/tran_active.png', '교통', 4),
          ],
        )
    );
  }
  @override
  build(BuildContext context){

  }
}