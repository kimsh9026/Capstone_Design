import 'dart:async' ;


class ExpansionPanelBloc extends Object{

  final _expansionPanelPressed = StreamController<bool>.broadcast() ;
  final _pressedButtonIndex = StreamController<int>.broadcast() ;

  Stream<bool> get expansionBarPressed => _expansionPanelPressed.stream ;
  Stream<int> get pressedButtonIndex => _pressedButtonIndex.stream ;

  Function(bool) get setExpansionBarPressed => _expansionPanelPressed.sink.add ;
  Function(int) get setPressedButtonIndex => _pressedButtonIndex.sink.add ;

  dispose(){
    _expansionPanelPressed.close() ;
    _pressedButtonIndex.close() ;
  }

}