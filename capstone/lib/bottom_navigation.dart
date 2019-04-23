// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/bloc_provider.dart';
import 'package:capstone/feed_page_codes/feed_page.dart';

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
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
  }

  final BottomNavigationBarItem item;
  final AnimationController controller;

}

class BottomNavigation extends StatefulWidget {

  static const String routeName = '/material/bottom_navigation';

  void stateClear() => _BottomNavigationState().clear() ;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();

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
        icon: const Icon(Icons.access_alarm),
        title: 'ProfilePage',
        color: Colors.deepPurple,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.cloud_queue),
        title: 'MatchingPage',
        color: Colors.teal,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.favorite),
        icon: const Icon(Icons.favorite_border),
        title: 'FeedPage',
        color: Colors.indigo,
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.event_available),
        title: 'Event',
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
    return BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        BlocProvider.of(context).bottomBarBloc.setBottomBarPressed(index) ;
        setState((){
          animate(index) ;
        }) ;
      },
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
