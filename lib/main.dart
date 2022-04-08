import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vtemeqr/bloc/list_screen_bloc.dart';
import 'package:vtemeqr/bloc/qr_screen_bloc.dart';
import 'package:vtemeqr/bloc/settings_screen_bloc.dart';
import 'package:vtemeqr/model/qr_screen_bloc_model.dart';
import 'package:vtemeqr/model/settings_screen_model.dart';
import 'package:vtemeqr/screens/camera2_0.dart';

import 'model/list_screen_bloc_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<QrScreenBloc>(
    QrScreenBloc(
      QrScreenBlocState(),
    ),
  );
  GetIt.instance.registerSingleton<ListScreenBloc>(
    ListScreenBloc(
      ListScreenBlocState(),
    ),
  );
  GetIt.instance.registerSingleton<SettingsScreenBloc>(
    SettingsScreenBloc(
      SettingsScreenBlocState(
        priceVIP: prefs.getInt('VIP'),
        priceFriend: prefs.getInt('Friend'),
        priceGuest: prefs.getInt('Guest'),
      ),
    ),
  );
  runApp(
    Phoenix(
      child: const QRViewScreen(),
    ),
  );
}
