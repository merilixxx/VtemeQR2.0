import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vtemeqr/bloc/qr_screen_bloc.dart';
import 'package:vtemeqr/model/qr_screen_bloc_model.dart';

import 'list_screen.dart';
import 'settings_screen.dart';

final bloc = GetIt.instance.get<QrScreenBloc>();

class QRViewScreen extends StatefulWidget {
  const QRViewScreen({Key? key}) : super(key: key);

  @override
  State<QRViewScreen> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _showButton = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                  Image.asset("assets/images/qr_code.png",
                      width: 150, height: 150),
                ],
              ),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 220, 63),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListScreen(),
                  ),
                ),
                icon: Image.asset("assets/images/menu.png",
                    width: 32, height: 32),
                tooltip: 'Список',
              );
            },
          ),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Image.asset("assets/images/settings_icon.png",
                      width: 32, height: 32),
                  tooltip: 'Настройки',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _showButton
            ? RaisedButton(
                info: result!.code.toString(),
                resume: _resumeCamera,
              )
            : null,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(
          () {
            result = scanData;
            _showButton = !_showButton;
            controller.pauseCamera();
          },
        );
      },
    );
  }

  void _resumeCamera() {
    controller!.resumeCamera();
    _showButton = !_showButton;
    result = Barcode(
      null,
      BarcodeFormat.qrcode,
      null,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class RaisedButton extends StatelessWidget {
  const RaisedButton({Key? key, required this.info, required this.resume})
      : super(key: key);
  final info;
  final VoidCallback resume;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color.fromARGB(255, 244, 220, 63),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => PopUpInformation(
          info: info,
          resume: resume,
        ),
      ),
      label: const Text("Сканировать код"),
    );
  }
}

class PopUpInformation extends StatelessWidget {
  const PopUpInformation({Key? key, required this.info, required this.resume})
      : super(key: key);
  final info;
  final VoidCallback resume;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrScreenBloc, QrScreenBlocState>(
      bloc: bloc,
      builder: (context, state) {
        return AlertDialog(
          content: Text(info),
          actions: <Widget>[
            TextButton(
              onPressed: () => bloc.connectSQL(),
              child: const Text("Сохранить"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resume;
              },
              child: const Text("Закрыть"),
            ),
          ],
        );
      },
    );
  }
}
