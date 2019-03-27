import 'package:capstone/BottomNavigation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:capstone/BlocProvider.dart' ;

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class CustomDatePicker extends StatefulWidget{

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();

}
class _CustomDatePickerState extends State<CustomDatePicker> {

  // Value that is shown in the date picker in date mode.
  DateTime date = DateTime.now();

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: date,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => date = newDateTime);
                },
              ),
            );
          },
        );
      },
      child: new Container(
        padding: EdgeInsets.only(top:3),
        child:
            Text(
              DateFormat.yMMMd().format(date),
              style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.activeBlue),
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDatePicker(context) ;
  }
}

class CustomTimePicker extends StatefulWidget{

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();

}
class _CustomTimePickerState extends State<CustomTimePicker> {

  // Value that is shown in the date picker in time mode.
  DateTime time = DateTime.now();

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: time,
                  onDateTimeChanged: (DateTime newDateTime){
                    setState(() => time = newDateTime);
                  },
                ),
              );
            },
          );
        },
        child: new Container(
          padding: EdgeInsets.only(top:3),
          child:
          Text(
            DateFormat.jm().format(time),
            style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.activeBlue),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimePicker(context) ;
  }
}

class ExpansionBlock extends StatefulWidget{

  @override
  _ExpansionBlockState createState() => _ExpansionBlockState() ;
}

class _ExpansionBlockState extends State<ExpansionBlock> {
  bool isExpanded = false;
  ConstrainedBox expansionBox ;
  Widget expansionDateTime(context, String string, child){
    return Container(
        width: double.infinity,
        color: Colors.white,
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
              flex: 6,
              child: child,
            )
          ],
        )
    );
  }

  Widget expansionBlock(context){
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 30,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex:2,
            child: Container(),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    print("tapped");
                    BlocProvider.of(context).expansionPanelBloc.setExpansionBarPressed(true) ;
                    isExpanded = !isExpanded ;
                    build(context) ;
                    },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('상세설명적용'),
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

  @override
  Widget build(BuildContext context) {
    Container expansionChild = Container(
      color: Colors.limeAccent,
      width: 500,
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

    return StreamBuilder(
        stream: BlocProvider.of(context).expansionPanelBloc.expansionBarPressed,
        builder: (context, snapshot){
          return AnimatedCrossFade(
            firstChild: expansionBlock(context),
            secondChild: Column(
              children: <Widget>[
                expansionChild,
                expansionBlock(context),
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


class ProfilePage extends StatelessWidget {

  Widget searchingBlock(){
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '제목, 내용 또는 키워드를 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 15,
        ),
        suffixIcon: Icon(Icons.search,color: Colors.blue),
        fillColor: Colors.black,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    print("Profile Build") ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions:
        <Widget>[
          PopupMenuButton<BottomNavigationBarType>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: Text('Something1'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: Text('something2'),
              )
            ],
          )
        ],

      ),
      body: Column(
        children: <Widget>[
          searchingBlock(),
//          new Container(
//            color: Colors.limeAccent,
//            width: 500,
//            height: 200,
//            child: Form(
//              child: expansionBlock(
//                context,
//                Column(
//                  children: <Widget>[
//                    Expanded(
//                        flex: 1,
//                        child: expansionDateTime(context,'날짜',CustomDatePicker())
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: expansionDateTime(context,'시간',CustomTimePicker()),
//                    ),
//                    Expanded(
//                      flex: 4,
//                      child: expansionDateTime(context,'목적',CustomTimePicker()),
//                    ),
//                  ],
//                ),
//              )
//            ),
//          ),
          ExpansionBlock(),
          Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Profile..',
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.white,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}