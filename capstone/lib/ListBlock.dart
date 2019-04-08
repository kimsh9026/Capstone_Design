import 'package:flutter/material.dart';
import 'package:capstone/CustomDateTimeFormField.dart' ;
import 'package:capstone/ChatRoom.dart';
import 'package:capstone/RoomCard.dart';
import 'package:capstone/BlocProvider.dart' ;
import 'package:capstone/RoomInfo.dart' ;
//import 'package:capstone/test/DetailPage.dart' ;

/*

* createRoom과 분리 필요?

*/

class ListBlock extends StatelessWidget {

  final formKey = GlobalKey<FormState>() ;
  RoomInfo roomInfo = RoomInfo();
  ListBlock();

  Widget _buildList(context) {
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.roomList,
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
                          onSaved: (str) => roomInfo.roomName = str,
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
              validator: (DateTime date) => date.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) ? null : '지금보다 이전 날짜입니다',
              onSaved: (DateTime date) => roomInfo.date = date,
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
                  validator: (DateTime date) => date.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second))? null : '지금보다 이전 시간입니다',
                  onSaved: (DateTime date) => roomInfo.time = date,
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
      BlocProvider.of(context).roomBloc.registerRoom(roomInfo) ;
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



