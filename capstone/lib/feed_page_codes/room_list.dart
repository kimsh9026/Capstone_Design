import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:capstone/matching_page_codes/room_add_map_api.dart' ;
import 'package:flutter/material.dart';
import 'package:capstone/custom_widgets/custom_datetime_form_field.dart';
import 'package:capstone/feed_page_codes/feed_room_card.dart';
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:numberpicker/numberpicker.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class RoomList extends StatelessWidget {

  final formKey = GlobalKey<FormState>() ;
  RoomInfo roomInfo = RoomInfo();
  int _purposeIndex = 1 ;
  int _numberOfMembers = 3 ;
  String country ;
  String vicinity ;
  String locationName ;
  Location location ;

  Widget _buildList(context) {
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.isRoomFinding,
      builder: (context, snapshot){
        return StreamBuilder(
            stream: BlocProvider.of(context).roomBloc.roomList,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return const Text('') ;
              return Container(
                child: ListView.builder(
//                  reverse: true,
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
                    return FeedRoomCard(context, snapshot.data.documents[int]);
                  },
                ),
              ) ;
            }
        ) ;
      }
    ) ;


  }

  Widget _createRoomTitleContainer(BuildContext context){
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
//                color: Colors.blue,
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
//                  color: Colors.yellow,
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
    ) ;
  }

  Widget _createRoomDateContainer(BuildContext context){
    return Container(
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
    ) ;
  }

  Widget _createRoomTimeContainer(BuildContext context){
    return Container(
        height: 40,
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
    ) ;
  }

  Widget purposeIconButton(BuildContext context, String path, String name, bool isActive, int index){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 60,
                child: FlatButton(
                    shape: CircleBorder(),
                    onPressed: (){
                      _purposeIndex = index ;
                      BlocProvider.of(context).createRoomBloc.setPressedButtonIndex(index) ;
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Image.asset(path)
                )
            ),
            Text(
              name,
              style: TextStyle(
                color: !isActive ? Colors.grey :
                (index == 1 ? Colors.green : (index == 2 ? Colors.orange :
                (index == 3 ? Colors.purpleAccent : Colors.blueAccent))),
              ),
            ),
          ],
        )
    );
  }

  Widget purposeIconAnimation(BuildContext context, String path, String activePath, String name, int index){
    return AnimatedCrossFade(
      firstChild: purposeIconButton(context, path, name, false, index),
      secondChild: purposeIconButton(context, activePath, name, true, index),
      firstCurve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: _purposeIndex == index ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 200),
    ) ;
  }

  Widget purposeContainer(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of(context).createRoomBloc.pressedButtonIndex,
        builder: (context, snapshot) {
          return Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  purposeIconAnimation(context, 'Images/category_ui/buddy.png',
                      'Images/category_ui/buddy_active.png', '동행', 1),
                  purposeIconAnimation(context, 'Images/category_ui/meal.png',
                      'Images/category_ui/meal_active.png', '식사', 2),
                  purposeIconAnimation(context, 'Images/category_ui/stay.png',
                      'Images/category_ui/stay_active.png', '숙소', 3),
                  purposeIconAnimation(context, 'Images/category_ui/tran.png',
                      'Images/category_ui/tran_active.png', '교통', 4),
                ],
              )
          );
        }
    );
  }

  Widget _createRoomPurposeContainer(context){
    return Container(
      height: 140,
      child: Column(
        children: <Widget>[

          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.only(top: 2),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '목적',
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.center,
                      )
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
              ],
            )
          ),
          Expanded(
            flex: 5,
            child: purposeContainer(context),
          )
        ],
      ),
    ) ;
  }
  void _showNumberDialog(context) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 5,
            title: new Text("인원"),
            initialIntegerValue: _numberOfMembers,
          );
        }
    ).then((int value) {
      if (value != null) {
        _numberOfMembers = value;
        BlocProvider.of(context).createRoomBloc.setMemberNumberChanged(true) ;
      }
    });
  }

  Widget _createNumberOfMembersContainer(BuildContext context){
    return Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  child: Text(
                    '인원',
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
                    flex: 1,
                    child: StreamBuilder(
                      stream: BlocProvider.of(context).createRoomBloc.memberNumberChanged,
                      builder: (context, snapshot){
                        return  FlatButton(
                          padding: EdgeInsets.only(top: 2, right: 25),
                            onPressed: () => _showNumberDialog(context),
                            child: Text(
                              '${_numberOfMembers} 명',
                              style: TextStyle(color: Colors.blueAccent),
                              textAlign: TextAlign.left,
                            )
                        ) ;
                      },
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  )
                ],
              )

            ),
          ],
        )
    ) ;
  }

  Widget _createRoomMapContainer(context){
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Row(
                children:
                <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.only(top: 2),
                        alignment: Alignment.center,
                        child: Text(
                          '위치',
                          style: Theme.of(context).textTheme.body1,
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: StreamBuilder(
                      stream: BlocProvider.of(context).mapBloc.location,
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          return Text('위치 정보를 가져오는 중입니다.', style: TextStyle(color: Colors.grey), overflow: TextOverflow.fade,) ;
                        }
                        else{
                          print(snapshot.data['country']) ;
                          country = snapshot.data['country'] ;
                          vicinity = snapshot.data['vicinity'] ;
                          locationName = snapshot.data['name'] ;
                          location = Location(snapshot.data['center'].latitude, snapshot.data['center'].longitude);
                          return Text(snapshot.data['name']) ;
                        }
                      }
                    ),
                  ),
                ],
              )
          ),
          Expanded(
            flex: 7,
            child: RoomAddMapApi(),
          )
        ],
      ),
    ) ;
  }

  Widget _createRoomBody(BuildContext context){
    roomInfo.clear() ;
    _numberOfMembers = 3 ;
    return Container(
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _createRoomTitleContainer(context),
                Padding(
                  padding: EdgeInsets.only(top:15),
                ),
                _createRoomDateContainer(context),
                Padding(
                  padding: EdgeInsets.only(top:5),
                ),
                _createRoomTimeContainer(context),
                Padding(
                  padding: EdgeInsets.only(top:5),
                ),
                _createRoomPurposeContainer(context),
                Padding(
                  padding: EdgeInsets.only(top:5),
                ),
                _createNumberOfMembersContainer(context),
                Padding(
                  padding: EdgeInsets.only(top:5),
                ),
                _createRoomMapContainer(context),
              ],
            )
        )
    );
  }

  void validate(context){
    final form = formKey.currentState ;
    if(form.validate()){
      form.save() ;
      print(_numberOfMembers) ;
      roomInfo.totalNumber = _numberOfMembers ;
      roomInfo.roomPurpose = _purposeIndex == 1 ? '동행' :
      (_purposeIndex == 2 ? '식사' : (_purposeIndex == 3 ? '숙소' : '교통')) ;
      roomInfo.roomLeaderUID = FireAuthProvider.user.uid ;
      roomInfo.meetingLocation = locationName ;
      roomInfo.country = country ;
      roomInfo.location = location ;
      roomInfo.vicinity = vicinity ;
      BlocProvider.of(context).roomBloc.registerRoom(roomInfo);
      Navigator.pop(context) ;
      BlocProvider.of(context).roomBloc.setRoomEntering(roomInfo) ;
      BlocProvider.of(context).bottomBarBloc.setBottomBarPressed(3) ;
    }
  }

  // meetingDateTime이 하루 지난 날짜로 등록된다!
  Widget createNewRoom(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
    _purposeIndex = 1;
    return _buildList(context);
  }
}



