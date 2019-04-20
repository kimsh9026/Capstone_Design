import 'package:flutter/material.dart' ;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const double _kPickerSheetHeight = 216.0;

class CustomDatePicker extends StatefulWidget{
  FormFieldState<DateTime> state ;
  CustomDatePicker({this.state}) ;
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
                    setState(() {
                      date = newDateTime ;
                      widget.state.didChange(newDateTime) ;
                    });
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
  FormFieldState<DateTime> state ;
  CustomTimePicker({this.state}) ;
  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();

}
class _CustomTimePickerState extends State<CustomTimePicker> {

  // Value that is shown in the date picker in time mode.
  DateTime time = DateTime.now().toLocal();

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
                    setState(() {
                      time = newDateTime;
                      widget.state.didChange(newDateTime);
                    });
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
