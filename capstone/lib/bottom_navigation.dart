// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/bloc_provider.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  }) :
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(''),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) ;

  final BottomNavigationBarItem item;
  final AnimationController controller;

}

class BottomNavigation extends StatefulWidget {

  static const String routeName = '/material/bottom_navigation';

  _BottomNavigationState _botNavBarState;

  Function(int) get animate => _botNavBarState.animate;
  Function() get stateClear => _BottomNavigationState().clear ;
  @override
  _BottomNavigationState createState() {
    _botNavBarState = _BottomNavigationState() ;
    return _botNavBarState ;
  }
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin
{
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        activeIcon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/person_active.PNG'),
        ),
        icon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/person.PNG'),
        ),
        color: Colors.deepPurple,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/matching_active.PNG'),
        ),
        icon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/matching.PNG'),
        ),
        color: Colors.teal,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/feed_active.PNG'),
        ),
        icon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/feed.PNG'),
        ),
        color: Colors.indigo,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/chat_active.PNG'),
        ),
        icon: Image(
          width: 30,
          height: 30,
          image: AssetImage('Images/bottom_bar_UI/chat.PNG'),
        ),
        color: Colors.pink,
        vsync: this,
      )
    ];

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of(context).bottomBarBloc.bottomBarPressed,
      builder:(context,snapshot){
       return BottomNavigationBar(
          items: _navigationViews
              .map<BottomNavigationBarItem>((NavigationIconView navigationView) => navigationView.item)
              .toList(),
          currentIndex: _currentIndex,
          type: _type,
          onTap: (int index) {
            BlocProvider.of(context).bottomBarBloc.setBottomBarPressed(index) ;
          },
        ) ;
      }
    ) ;
  }

  void clear(){
    _currentIndex = 0 ;
  }

  void animate(int index){
    _navigationViews[_currentIndex].controller.reverse();
    _currentIndex = index;
    _navigationViews[_currentIndex].controller.forward();
  }
}
