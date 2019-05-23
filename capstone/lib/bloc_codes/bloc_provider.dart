import 'package:capstone/bloc_codes/MatchingBloc.dart';
import 'package:capstone/bloc_codes/create_room_bloc.dart';
import 'package:capstone/bloc_codes/map_bloc.dart';
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
    createRoomBloc : CreateRoomBloc(),
    mapBloc : MapBloc(),
    matchingBloc : MatchingBloc(),
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
  final CreateRoomBloc createRoomBloc ;
  final MapBloc mapBloc ;
  final MatchingBloc matchingBloc ;

  _BlocState({
    this.authBloc,
    this.roomBloc,
    this.bottomBarBloc,
    this.expansionPanelBloc,
    this.createRoomBloc,
    this.mapBloc,
    this.matchingBloc,
  });
}
