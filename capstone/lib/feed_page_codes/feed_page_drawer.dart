
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPageDrawer extends StatefulWidget{

  @override
  State<FeedPageDrawer> createState() => FeedPageDrawerState() ;
}

class FeedPageDrawerState extends State<FeedPageDrawer> {



  @override
  Widget build(BuildContext context) {
    final header = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
          color: Color.fromRGBO(47, 146, 217, 0.9)
      ),
      accountName: Text('카테고리'),
    ) ;
    final items = Column(
      children: <Widget>[
        Expanded(
            flex: 4,
            child: header
        ),
        Expanded(
            flex: 10,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('나라별'),
                  ),
                  ListTile(
                    title: Text('목적별'),
                  ),
                ],
              )
            )
        ),
      ],
    ) ;

    return Drawer(
      child: items,
    ) ;
  }
}