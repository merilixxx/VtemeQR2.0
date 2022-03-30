import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'settings_screen.dart';

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

  final snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {},
    ),
  );

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
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 220, 63),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () => Navigator.pushReplacement(
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
                  onPressed: () => Navigator.pushReplacement(
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
    setState(() {
      controller?.resumeCamera();
      _showButton = !_showButton;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 220, 63),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Image.asset("assets/images/arrows.png",
                  width: 32, height: 32),
              tooltip: 'Назад',
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Image.asset("assets/images/calendar.png",
                    width: 32, height: 32),
                tooltip: 'Выбор даты',
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
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
    return AlertDialog(
      content: Text(info),
      actions: <Widget>[
        TextButton(
          onPressed: () {},
          child: const Text("Сохранить"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Закрыть"),
        ),
      ],
    );
  }
}
