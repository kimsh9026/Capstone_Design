import 'package:capstone/fire_base_codes/fire_store_provider.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';


class MatchingBloc extends Object {

  final _isMatching = FirestoreProvider().matchingStream;

  Stream<QuerySnapshot> get isMatching => _isMatching() ;

}