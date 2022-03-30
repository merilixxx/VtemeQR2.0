import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vtemeqr/bloc/qr_screen_bloc.dart';
import 'package:vtemeqr/model/qr_screen_bloc_model.dart';
import 'package:vtemeqr/screens/camera2_0.dart';

void main() {
  GetIt.instance.registerSingleton<QrScreenBloc>(
    QrScreenBloc(
      QrScreenBlocState(),
    ),
  );
  runApp(
    const QRViewScreen(),
  );
}
