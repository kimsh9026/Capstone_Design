import 'package:capstone/CustomPickers.dart' ;
import 'package:flutter/material.dart';

class CustomDateTimeFormField extends FormField<DateTime>{

  CustomDateTimeFormField({
    bool isDate = true,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    DateTime initialValue,
    bool autoValidate = false,
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autoValidate,
      builder: (FormFieldState<DateTime> state){
        print('datePicker ! ${state.value.toString()}') ;
        return Column(
          children: <Widget>[
            Container(
              alignment: Alignment(-1,0),
              child: isDate? CustomDatePicker(state: state) : CustomTimePicker(state: state),
            ),
            Container(
              alignment: Alignment(-1,0),
              child: state.hasError?
              Text(
                  state.errorText,
                  style: TextStyle(
                    color: Colors.red,
                  )
              )
                  : Container(),
            ),
          ],
        )
        ;
      }
  ) ;

}