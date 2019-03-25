import 'package:capstone/BottomNavigation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class CupertinoPicker extends StatefulWidget{

  @override
  _CupertinoPickerState createState() => _CupertinoPickerState();

}
class _CupertinoPickerState extends State<CupertinoPicker> {

  // Value that is shown in the date picker in date mode.
  DateTime date = DateTime.now();

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
      child:

      new Container(
        child:
            Text(
              DateFormat.yMMMd().format(date),
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child :(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('날짜'),
                    _buildDatePicker(context),
                  ],
                )
            )
        ),
        Expanded(
          flex: 5,
          child: Container(),
        )
      ],
    );


  }


}


class ProfilePage extends StatelessWidget {

  BottomNavigation botNavBar ;

  Widget searchingBlock(){
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '제목, 내용 또는 키워드를 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 13,
        ),
        suffixIcon: Icon(Icons.search),
        fillColor: Colors.black,
      ),
    );
  }

  ProfilePage(this.botNavBar) ;

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
          CupertinoPicker(),
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
//          Container(
//            color: Colors.blue,
//            width: width,
//            height: 100,
//            child:
//          ),
        ],
      ),
//      bottomNavigationBar: botNavBar,
    );
  }
}