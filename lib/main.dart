import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vtemeqr/bloc/list_screen_bloc.dart';
import 'package:vtemeqr/bloc/qr_screen_bloc.dart';
import 'package:vtemeqr/model/qr_screen_bloc_model.dart';
import 'package:vtemeqr/screens/camera2_0.dart';

import 'model/list_screen_bloc_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<QrScreenBloc>(
    QrScreenBloc(
      QrScreenBlocState(),
    ),
  );
  GetIt.instance.registerSingleton<ListScreenBloc>(
    ListScreenBloc(
      ListScreenBlocState(
        users: Users(
          name: '',
          nick: '',
          pay: 0,
          status: '',
        ),
      ),
    ),
  );
  runApp(
    const QRViewScreen(),
  );
}
