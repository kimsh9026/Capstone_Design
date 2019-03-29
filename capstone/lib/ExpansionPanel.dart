import 'package:flutter/material.dart' ;
import 'package:capstone/CustomPickers.dart' ;
import 'package:capstone/BlocProvider.dart' ;


class ExpansionBlock extends StatefulWidget{

  @override
  _ExpansionBlockState createState() => _ExpansionBlockState() ;
}
class _ExpansionBlockState extends State<ExpansionBlock> {
  bool isExpanded = false;

  Widget expansionDateTime(context, String string, child){
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex:1,
              child: Text(
                string,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:7),
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: child,
            ),
            Expanded(
              flex: 4,
              child: Container(),
            )
          ],
        )
    );
  }

  Widget expansionHeader(context,txt){

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 20,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex:2,
            child: Container(
              width: double.infinity,
              color: Colors.black,
            ),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    print("tapped");
                    BlocProvider.of(context).expansionPanelBloc.setExpansionBarPressed(true) ;
                    isExpanded = !isExpanded ;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      txt,
                      ExpandIcon(
                        isExpanded: isExpanded,
                      )
                    ],
                  )
              )
          )
        ],
      ),
    ) ;
  }

  Widget expansionChild(){
    return Container(
      width: 400,
      height: 200,
      child: Form(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: expansionDateTime(context,'날짜',CustomDatePicker())
            ),
            Expanded(
              flex: 1,
              child: expansionDateTime(context,'시간',CustomTimePicker()),
            ),
            Expanded(
              flex: 4,
              child: expansionDateTime(context,'목적',CustomTimePicker()),
            ),
          ],
        ),
      ),
    ) ;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: BlocProvider.of(context).expansionPanelBloc.expansionBarPressed,
        builder: (context, snapshot){
          return AnimatedCrossFade(
            firstChild: expansionHeader(context,Text('상세 옵션')),
            secondChild: Column(
              children: <Widget>[
                expansionChild(),
                expansionHeader(context,Text('적용')),
              ],
            ),
            firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
            secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
            sizeCurve: Curves.fastOutSlowIn,
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          );
        }
    );
  }
}
