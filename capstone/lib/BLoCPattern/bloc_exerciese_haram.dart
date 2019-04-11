import 'bloc_exercise_haram2.dart' ;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// 함수에게 별칭을 부여하는 것.
// AsyncBlocEventStateBuilder는 context와 state를 받아서 Widget 타입을 리턴한다는 의미.
// 타입은 BlocState이다.
typedef Widget AsyncBlocEventStateBuilder<BlocState>(BuildContext context, BlocState state);

class BlocBuilder<BlocEvent,BlocState> extends StatelessWidget {
  const BlocBuilder({
    Key key,
    @required this.builder,
    @required this.bloc
  }) : assert(builder!=null),assert(bloc!=null),super(key: key);

  final BlocEventStateBase<BlocEvent, BlocState> bloc;
  final AsyncBlocEventStateBuilder<BlocState> builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlocState>(
      stream: bloc.state,
      initialData: bloc.initialState,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot){
        return builder(context, snapshot.data);
      },
    );
  }
}