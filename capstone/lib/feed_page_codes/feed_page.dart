import 'package:capstone/feed_page_codes/feed_page_drawer.dart';
import 'package:flutter/material.dart';
import 'package:capstone/feed_page_codes/room_list.dart';
import 'package:capstone/custom_widgets/custom_expansion_panel.dart';
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/room_info.dart';

class FeedPage extends StatelessWidget {

  RoomList roomList = new RoomList();

  Widget searchingBlock(context) {
    RoomInfo roomInfo = RoomInfo();
    return Container(
        color: Colors.white,
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '제목, 내용 또는 키워드를 입력해주세요',
            hintStyle: TextStyle(
              fontSize: 15,
            ),
            suffixIcon: InkWell(
              child: Icon(Icons.search, color: Colors.blue),
            ),
            fillColor: Colors.black,
          ),
          onChanged: (str) {
            roomInfo.roomName = str ;
            BlocProvider.of(context).roomBloc.setIsRoomFinding(true) ;
            BlocProvider.of(context).roomBloc.setRoomFinding(roomInfo) ;
          }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(215, 238, 247, 0.9),
      drawer: FeedPageDrawer(),
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromRGBO(47, 146, 217, 0.9),
          ),
          toolbarOpacity: 1,
          elevation: 0.1,
          bottomOpacity: 1,
          title: Text(
            '게시판',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          searchingBlock(context),
          ExpansionBlock(),
          new Divider(color: Colors.black45, indent: 0.0, height: 0,),
          Expanded(
            child: roomList,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return roomList.createNewRoom(context) ;
          })) ;
        },
        tooltip: 'create room',
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
