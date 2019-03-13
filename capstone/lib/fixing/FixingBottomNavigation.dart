// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:capstone/fixing/BlocProvider.dart' ;
import 'package:capstone/fixing/FeedPage.dart' ;

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        _title = title,
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
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;
/*
  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(//시작 끝 위지
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
*/
}

class BottomNavigation extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin
{
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: 'Alarm',
        color: Colors.deepPurple,
        vsync: this,
      ),
//      NavigationIconView(
//        activeIcon: CustomIcon(),
//        icon: CustomInactiveIcon(),
//        title: 'Box',
//        color: Colors.deepOrange,
//        vsync: this,
//      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.cloud_queue),
        title: 'Cloud',
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
/*
  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions);
  }
*/
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        //이 부분도 넘겨주는게?
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
          //navigation bar가 tap 된 경우 blocProvider
          BlocProvider.of(context).centerBloc.setBottomBarPressed(
              _navigationViews[_currentIndex]._title
          ) ;
        });
      },
    );

    Text _titleText ;
    /*
    * BottomNavigation Bar class 내에서 Scaffold, AppBar 등 모두 생성
    -> 분리 필요
    * Navigation Bar만 ??

     */

    StreamBuilder(
        stream : BlocProvider.of(context).centerBloc.bottomBarPressed,
        builder: (context,snapshot) {
          if (!snapshot.hasData || snapshot.data == 'Alarm') {
            _titleText = Text('Alarm') ;
          }
          else if (snapshot.data == 'Cloud'){
            _titleText = Text('Cloud') ;

          }
          else if (snapshot.data == 'FeedPage'){
            _titleText = Text('FeedPage') ;

          }
          else{
            _titleText = Text('Yeah') ;

          }
        }

    );

    return StreamBuilder(
      stream : BlocProvider.of(context).centerBloc.bottomBarPressed,
      builder: (context, snapshot){
          return Scaffold(
            appBar: AppBar(
              title: _titleText,
              actions:

              //bloc 처리 필요
              <Widget>[
                PopupMenuButton<BottomNavigationBarType>(
                  onSelected: (BottomNavigationBarType value) {
                    setState(() {
                      _type = value;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
                    const PopupMenuItem<BottomNavigationBarType>(
                      value: BottomNavigationBarType.fixed,
                      child: Text('Fixed'),
                    ),
                    const PopupMenuItem<BottomNavigationBarType>(
                      value: BottomNavigationBarType.shifting,
                      child: Text('Shifting'),
                    )
                  ],
                )
              ],

            ),
            body: Center(
                child : StreamBuilder(
                  stream : BlocProvider.of(context).centerBloc.bottomBarPressed,

                  builder: (context, snapshot){

                    if (!snapshot.hasData || snapshot.data != 'FeedPage') {
                      return Container(
                        color: Colors.blue,
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: Text(
                          'Testing..',
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        )),
                      );
                    }
                    else if(snapshot.data == 'FeedPage')
                      return FeedPage() ;

                  },
                )
            ),
            bottomNavigationBar: botNavBar,
          );
      } ,
    );

  }
}
