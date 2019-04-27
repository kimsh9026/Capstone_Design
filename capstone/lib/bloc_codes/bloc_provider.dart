import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/auth_bloc.dart';
import 'package:capstone/bloc_codes/room_bloc.dart';
import 'package:capstone/bloc_codes/bottom_bar_bloc.dart';
import 'package:capstone/bloc_codes/expansion_panel_bloc.dart';


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
