import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:capstone/custom_widgets/custom_datetime_form_field.dart';
import 'package:capstone/feed_page_codes/room_card.dart';
import 'package:capstone/bloc_codes/BlocProvider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';

/*

* createRoom과 분리 필요?

*/

class RoomList extends StatelessWidget {

  final formKey = GlobalKey<FormState>() ;
  RoomInfo roomInfo = RoomInfo();

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
              return new RoomCard(context, snapshot.data.documents[int]);
            },
          );
        }
    );
  }

  Widget _createRoomBody(BuildContext context){
    roomInfo.clear() ;
    return Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        '제목',
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.center,
                      )
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                        alignment: Alignment.topCenter,
                        color: Colors.yellow,
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
                )
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top:15),
        ),
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 2),
                    alignment: Alignment.topCenter,
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
                    onSaved: (DateTime date) => roomInfo.meetingDate = date,
                  )
              ),
            ],
          )
        ),
          Padding(
            padding: EdgeInsets.only(top:5),
          ),
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.only(top: 2),
                        alignment: Alignment.topCenter,
                      child: Text(
                        '시간',
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.center,
                      )
                    ),
                ),
                Expanded(
                  flex: 5,
                  child: CustomDateTimeFormField(
                    isDate: false,
                    initialValue: DateTime.now(),
                    validator: (DateTime date) => date.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second))? null : '지금보다 이전 시간입니다',
                    onSaved: (DateTime date) => roomInfo.meetingTime = date,
                  ),
                ),
              ],
            )
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
      print('room Leader: ${FireAuthProvider.user.email}');
      roomInfo.roomLeaderName = FireAuthProvider.user.email ;
      BlocProvider.of(context).roomBloc.registerRoom(roomInfo);
      Navigator.pop(context) ;
      BlocProvider.of(context).roomBloc.setEnterRoom(roomInfo) ;
      BlocProvider.of(context).bottomBarBloc.setBottomBarPressed(3) ;
    }
  }

  Widget createNewRoom(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          actions: <Widget>[
            FlatButton(
              padding: EdgeInsets.only(left:15),
              child: Text(
                  '완료',
                  style: Theme.of(context).textTheme.title.copyWith(fontSize: 15)
              ),
              onPressed: (){
                validate(context) ;
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
      body: _createRoomBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}



