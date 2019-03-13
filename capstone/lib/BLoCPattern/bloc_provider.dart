import 'package:flutter/material.dart';
import 'AuthBloc.dart' ;
import 'RoomBloc.dart' ;
import 'CenterBloc.dart' ;



class BlocProvider extends InheritedWidget {
  final blocState = new _BlocState(
    authBloc: AuthBloc(),
    roomBloc: RoomBloc(),
    centerBloc: CenterBloc(),
  );

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static _BlocState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider)
        .blocState; //context.inheritFromWidgetOfExactType(BlocProvider) => inheritedWidget type return
    //as로 BlocProvider 타입으로 바꿔주는듯
  }
}

class _BlocState {
  final AuthBloc authBloc;
  final RoomBloc roomBloc;
  final CenterBloc centerBloc;

  _BlocState({
    this.authBloc,
    this.roomBloc,
    this.centerBloc,
  });
}
