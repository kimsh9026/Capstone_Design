import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/AuthBloc.dart';
import 'package:capstone/bloc_codes/RoomBloc.dart';
import 'package:capstone/bloc_codes/BottomBarBloc.dart';
import 'package:capstone/bloc_codes/ExpansionPanelBloc.dart';


class BlocProvider extends InheritedWidget {
  final blocState = new _BlocState(
    authBloc: AuthBloc(),
    roomBloc: RoomBloc(),
    bottomBarBloc: BottomBarBloc(),
    expansionPanelBloc: ExpansionPanelBloc(),
  );

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static _BlocState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider)
        .blocState; //context.inheritFromWidgetOfExactType(BlocProvider) => inheritedWidget type return
  }
}

class _BlocState {
  final AuthBloc authBloc;
  final RoomBloc roomBloc;
  final BottomBarBloc bottomBarBloc;
  final ExpansionPanelBloc expansionPanelBloc;

  _BlocState({
    this.authBloc,
    this.roomBloc,
    this.bottomBarBloc,
    this.expansionPanelBloc,
  });
}
