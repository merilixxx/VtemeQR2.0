import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtemeqr/model/list_screen_bloc_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class ListScreenBloc extends Cubit<ListScreenBlocState> {
  ListScreenBloc(ListScreenBlocState initialState) : super(initialState);

  Future getData() async {
    final ref = FirebaseDatabase(
            databaseURL:
                "https://qrvteme-default-rtdb.europe-west1.firebasedatabase.app")
        .reference();
    final snapshot = await ref.child('01_04_2022/').once();
    if (snapshot.snapshot.exists) {
      print(snapshot.snapshot.value);
      // final data = await http.get(
      //   Uri.parse(
      //     snapshot.value.toString(),
      //   ),
      // );
      // emit(
      //   ListScreenBlocState(
      //     users: Users.fromJson(
      //       jsonDecode(
      //         data.body,
      //       ),
      //     ),
      //   ),
      // );
    } else {
      print('No data available.');
    }
  }
}
