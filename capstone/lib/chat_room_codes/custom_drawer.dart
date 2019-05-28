import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/chat_room_codes/chat_room_map_api.dart';
import 'package:capstone/chat_room_codes/users_Info_communicator.dart';
import 'package:capstone/feed_page_codes/room_info.dart';
import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'package:capstone/friend_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomDrawer extends StatefulWidget{
  RoomInfo _roomInfo ;
  BuildContext _context ;
  CustomDrawer(this._roomInfo, this._context) ;

  @override
  State<StatefulWidget> createState() {
    return CustomDrawerState();
  }
}

class CustomDrawerState extends State<CustomDrawer> with TickerProviderStateMixin{

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  BuildContext _context ;
  BuildContext _thisContext ;
  UsersInfoCommunicator _userInfoCommunicator ;
  RoomInfo _roomInfo ;
  List<Widget> _image ;
  List<String> _names ;
  List<String> _uids ;
  Widget _leaderImage ;
  String _leaderName ;
  String _leaderUID ;
  AnimationController _controller ;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState() ;
    _roomInfo = widget._roomInfo ;
    _userInfoCommunicator = UsersInfoCommunicator(widget._context) ;
    _image = List<Widget>() ;
    _names = List<String>() ;
    _uids = List<String>() ;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    _userInfoCommunicator.close() ;
    super.dispose();
  }

  void _getUsers(){
    _image.clear() ;
    _names.clear() ;
    _uids.clear() ;
    _userInfoCommunicator.usersImageURL.forEach((key, value) {
      if (key != _roomInfo.roomLeaderUID) {
        _image.add(Image.network(value));
      }
      else{
        _leaderImage = Image.network(value) ;
      }
    }) ;
      _userInfoCommunicator.usersDisplayName.forEach((key, value){
        if (key != _roomInfo.roomLeaderUID) {
          _names.add(value);
        }
        else{
          _leaderName = value ;
        }
    }) ;
    _userInfoCommunicator.usersUID.forEach((key, value){
      if (key != _roomInfo.roomLeaderUID) {
        _uids.add(value);
      }
      else{
        _leaderUID = value ;
      }
    }) ;
  }

  Widget _userCard(BuildContext context, int userNumber){
    return ListTile(
      leading: CircleAvatar(
        child: userNumber == _roomInfo.currentNumber ? _leaderImage
            : _image.elementAt(userNumber),
      ),
      title: userNumber == _roomInfo.currentNumber ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_leaderName),
          Padding(padding: EdgeInsets.only(left: 5)),
          Icon(Icons.grade,color: Colors.deepOrange,)
        ],
      ) : Text(_names.elementAt(userNumber)),
      onTap: (){
        if(userNumber == _roomInfo.currentNumber){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendProfilePage(_leaderUID)),
          );
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendProfilePage(_uids.elementAt(userNumber))),
          );
        }
      },
    );
  }

  void _showExitDialog(){
    showDialog(
        context: _thisContext,
      builder: (BuildContext context){
        return AlertDialog(
            content: Text(
              '정말 나가시겠습니까?',
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('나가기', style: TextStyle(color: Colors.blue),),
              onPressed: () { Navigator.pop(context, 'agree'); }
              )
            ]
        ) ;
      }
    )
    .then((value){
      if(value != null){
//        _userInfoCommunicator.close() ;
        FirestoreProvider().exitRoom(_roomInfo) ;
        Navigator.popUntil(_thisContext, ModalRoute.withName(Navigator.defaultRouteName)) ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _thisContext = context ;
    return StreamBuilder(
      stream: BlocProvider.of(context).roomBloc.didGetUserSnapshot,
      builder: (context, snapshot){
       if(!snapshot.hasData || !snapshot.data){
         return Drawer(
           child: Container(),
         ) ;
       }
       else{
         _getUsers() ;
         final header = UserAccountsDrawerHeader(
//           Todo: decoration: ,
         decoration: BoxDecoration(
           color: Color.fromRGBO(47, 146, 217, 0.9)
         ),
           onDetailsPressed: () {
             _showDrawerContents = !_showDrawerContents;
             if (_showDrawerContents)
               _controller.reverse();
             else
               _controller.forward();
           },
           accountName: Text(_roomInfo.roomName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17),),
           accountEmail: Text(_roomInfo.meetingLocation, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14),),
           currentAccountPicture: CircleAvatar(
               child: Image.network(_userInfoCommunicator.usersImageURL[_roomInfo.roomLeaderUID])
           ),
           otherAccountsPictures: _image,
         ) ;
         final items = Column(
           children: <Widget>[
             Expanded(
               flex: 5,
               child: header
             ),
             Expanded(
               flex: 10,
               child: MediaQuery.removePadding(
                   context: context,
                   removeTop: true,
                   child: Stack(
                     children: <Widget>[
                       // The initial contents of the drawer.
                       FadeTransition(
                           opacity: _drawerContentsOpacity,
                           child: ListView.builder(
                             itemCount: _userInfoCommunicator.usersDisplayName.length,
                             itemBuilder: (context, int,
                                 {
                                   shrinkWrap: true,
                                   padding: const EdgeInsets.only(
                                     top: 30.0,
                                     bottom: 30.0,
                                   ),
                                 }) {
                               if(int == 0){
                                 return _userCard(context, _roomInfo.currentNumber) ;
                               }
                               return _userCard(context, int-1) ;
                             },
                           )
                       ),
                       // The drawer's "details" view.
                       SlideTransition(
                         position: _drawerDetailsPosition,
                         child: FadeTransition(
                           opacity: ReverseAnimation(_drawerContentsOpacity),
                           child: ListView(
                             children: <Widget>[
                               ListTile(
                                 title: Text('방 이름',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                 subtitle: Text(_roomInfo.roomName, style: TextStyle(fontSize: 15, color: Colors.black), ),
                               ),
                               ListTile(
                                 title: Text('장소',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                 subtitle: Text(_roomInfo.meetingLocation, style: TextStyle(fontSize: 15, color: Colors.black),),
                               ),
                               ListTile(
                                 title: Text('일시',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                 subtitle: Text('${_roomInfo.meetingDateTime.toDate().year}년 ${_roomInfo.meetingDateTime.toDate().month}월 ${_roomInfo.meetingDateTime.toDate().day}일'
                                     ' ${_roomInfo.meetingDateTime.toDate().hour}시 ${_roomInfo.meetingDateTime.toDate().minute}분',
                                   style: TextStyle(fontSize: 15, color: Colors.black),),
                               ),
                               ListTile(
                                 title: Text('목적',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                 subtitle: Text(_roomInfo.roomPurpose, style: TextStyle(fontSize: 15, color: Colors.black),),
                               ),
                               ListTile(
                                 title: Text('위치',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                 subtitle: Text(_roomInfo.vicinity, style: TextStyle(fontSize: 15, color: Colors.black),),
                               ),
                               Container(
                                 height: 100,
                                 child : ChatRoomMapApi(LatLng(_roomInfo.location.lat, _roomInfo.location.lng)),
                               ),
//                               ListTile(
//                                 title: Text('내용',style: TextStyle(fontSize: 12, color: Colors.grey),),
//                                 subtitle: Text(_roomInfo.contents, style: TextStyle(fontSize: 15, color: Colors.black),),
//                               ),
                             ],
                           ),
                         ),
                       ),
                     ],
                   ),
               )
             ),
             Expanded(
                 flex: 1,
                 child: Column(
                   children: <Widget>[
                     Expanded(
                       flex: 1,
                       child: Divider(),
                     ),
                     Expanded(
                       flex: 15,
                       child: Row(
                         children: <Widget>[
                           Expanded(
                             flex: 1,
                             child: IconButton(
                               icon: Icon(Icons.exit_to_app),
                               onPressed: _showExitDialog,
                             ),
                           ),
                           Expanded(
                               flex: 4,
                               child: Container()
                           ),
                         ],
                       )
                     )

                   ],
                 )
             )
           ],
         ) ;
         return Drawer(
           child: items,
         ) ;
       }
      },
    ) ;
  }
}