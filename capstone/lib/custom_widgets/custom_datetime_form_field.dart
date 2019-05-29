import 'package:capstone/custom_widgets/custom_datetime_pickers.dart';
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
        return Column(
          children: <Widget>[
            Container(
              alignment: Alignment(-1,0),
              child: isDate? CustomDatePicker(state: state) : CustomTimePicker(formState: state),
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