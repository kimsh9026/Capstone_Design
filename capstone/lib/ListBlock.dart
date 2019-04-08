import 'package:flutter/material.dart';
import 'package:capstone/ChatRoom.dart';
import 'package:capstone/RoomCard.dart';
import 'package:capstone/BlocProvider.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:capstone/CustomPickers.dart' ;

//import 'package:capstone/test/DetailPage.dart' ;

class ListBlock extends StatelessWidget {

  final formKey = GlobalKey<FormState>() ;
  List<dynamic> roomInfo = List();
  ListBlock();

  Widget _buildList(context) {
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.roomInfo,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const Text('Loading..') ;
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
          ),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, int,
              {
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 30.0,
                ),
              }) {
            print('has Data!') ;
            return new RoomCard(context, snapshot.data.documents[int]);
          },
        );
      }
    );
  }

  Widget detailRoomView(int number) {
    //   return DetailPage(chatRooms[number], new RoomCard(chatRooms[number]).) ;
  }

  Widget _createRoomBody(BuildContext context){
    roomInfo.clear() ;
    roomInfo.insert(0,'') ;
    roomInfo.insert(1, DateTime.now()) ;
    DateTime tempDate ;
    return Container(
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.black,
                          alignment: Alignment(0, 2),
                          child: Text(
                            '제목',
                            style: Theme.of(context).textTheme.body1,
                            textAlign: TextAlign.center,
                          )
                        ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                  ),
                                  validator: (str) => str.isEmpty ? '제목을 입력해주세요!' : null,
                                  onSaved: (str) {
                                    print('name onSaved! ${str}') ;
                                    roomInfo.removeAt(0) ;
                                    roomInfo.insert(0,str);
                                  }
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            )
                          ],
                        )
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:5),
                ),
                new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: Text(
                              '날짜',
                              style: Theme.of(context).textTheme.body1,
                              textAlign: TextAlign.center,
                            )
                        )
                    ),
                    Expanded(
                        flex: 5,
                        child: CustomDateTimeFormField(
                                isDate: true,
                                initialValue: DateTime.now(),
                                validator: (DateTime date)
                                {
                                  print('date validating! ${date.toString()}') ;
                                  return date.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) ? null : '지금보다 이전 날짜입니다' ;
                                },
                                onSaved: (DateTime date) {
                                  if(tempDate == null){
                                    tempDate = date ;
                                  }
                                  else{
                                    tempDate = DateTime(date.year, date.month, date.day, tempDate.hour, tempDate.minute, tempDate.second) ;
                                    roomInfo.removeAt(1) ;
                                    roomInfo.insert(1,tempDate) ;
                                    print('date onSaved!! ${roomInfo.elementAt(1)}') ;
                                  }
                                }
                            )
                        ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:5),
                ),
                new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Text(
                          '시간',
                          style: Theme.of(context).textTheme.body1,
                          textAlign: TextAlign.center,
                        )
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomDateTimeFormField(
                          isDate: false,
                          initialValue: DateTime.now(),
                          validator: (DateTime date)
                          {
                            print('time validating! ${date.toString()}') ;
                            return date.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second))?
                            null : '지금보다 이전 시간입니다' ;
                          },
                            onSaved: (DateTime date) {

                            if(tempDate == null){
                              tempDate = date ;
                            }
                            else{
                              tempDate = DateTime(tempDate.year, tempDate.month, tempDate.day, date.hour, date.minute, date.second) ;
                              roomInfo.removeAt(1) ;
                              roomInfo.insert(1,tempDate) ;
                              print('time onSaved!! ${roomInfo.elementAt(1)}') ;
                            }
//                            tempDate == null ? tempDate = date :
                            }
                        ),
                    ),
                  ],
                ),
              ],
            )
        )
    );
  }

  void validate(context){
    final form = formKey.currentState ;
    if(form.validate()){
      form.save() ;
      BlocProvider.of(context).roomBloc.setAddRoom(roomInfo) ;
    }
  }

  Widget createNewRoom(BuildContext context){
    print("create new Room") ;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          actions: <Widget>[
            //        PopupSearchButton()
            FlatButton(
              padding: EdgeInsets.only(left:15),
                child: Text(
                    '완료',
                    style: Theme.of(context).textTheme.title
                    .copyWith(fontSize: 15)
                ),
                onPressed: (){
                  validate(context) ;
                  print('tapped') ;
                },
              ),
          ],
          elevation: 0.1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            '모집글 작성',
            style: Theme.of(context).textTheme.title,
          ),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(47, 146, 217, 0.9),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body:

      _createRoomBody(context),

    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}

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

