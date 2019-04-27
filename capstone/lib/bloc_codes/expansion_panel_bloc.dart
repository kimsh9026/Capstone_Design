import 'dart:async' ;
import 'package:flutter/material.dart' ;


class ExpansionPanelBloc extends Object{

  final _ExpansionPanelPressed = StreamController<bool>.broadcast() ;

  Stream<bool> get expansionBarPressed => _ExpansionPanelPressed.stream ;

  Function(bool) get setExpansionBarPressed => _ExpansionPanelPressed.sink.add ;

  dispose(){
    _ExpansionPanelPressed.close() ;
  }

}