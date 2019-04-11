import 'package:flutter/material.dart';
import 'package:capstone/ExpansionPanel.dart' ;

/*
* Picker 접혔을 때 눌리지 않도록 처리 필요
 */

class ProfilePage extends StatelessWidget {

  Widget searchingBlock(){
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '제목, 내용 또는 키워드를 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 15,
        ),
        suffixIcon: Icon(Icons.search,color: Colors.blue),
        fillColor: Colors.black,
      ),
    );
  }


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
          ExpansionBlock(),
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
        ],
      ),
    );
  }
}