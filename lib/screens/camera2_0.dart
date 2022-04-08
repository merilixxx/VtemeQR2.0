import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
                      width: 175, height: 175),
                ],
              ),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 179, 91, 1),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset("assets/images/menu.png",
                    width: 32, height: 32),
                tooltip: 'Список',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListScreen(),
                  ),
                ),
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
}

class RaisedButton extends StatelessWidget {
  RaisedButton({
    Key? key,
    required this.info,
  }) : super(key: key);
  final info;

  String? nick;
  String? name;
  String? status;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color.fromRGBO(255, 179, 91, 1),
      onPressed: () {
        getString(info);
        showDialog(
          context: context,
          builder: (context) => PopUpInformation(
            name: name,
            nick: nick,
            status: status,
          ),
        );
      },
      label: const Text("Просмотр"),
    );
  }

  void getString(String info) {
    final regExpNick = RegExp(r'([а-я--]+)?\.?"([А-Яа-я]+)"', unicode: true);

    final regExpName = RegExp(r'/?;([А-Яа-я]+)', unicode: true);

    final regExpStatus =
        RegExp(r'(VIP)|(Гость Клуба)|(Друг Клуба)|(Новичок)', unicode: true);

    nick = regExpNick.stringMatch(info);
    name = regExpName.stringMatch(info);
    name = name!.split(';').last;
    status = regExpStatus.stringMatch(info);
  }
}

class PopUpInformation extends StatelessWidget {
  const PopUpInformation({
    Key? key,
    required this.name,
    required this.nick,
    required this.status,
  }) : super(key: key);
  final name;
  final nick;
  final status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrScreenBloc, QrScreenBlocState>(
      bloc: bloc,
      builder: (context, state) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              Text(nick),
              Text(status),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text("Добавить"),
            ),
            TextButton(
              onPressed: () {
                bloc.addQR(name, nick, status);
                Phoenix.rebirth(context);
              },
              child: const Text("Закрыть"),
            ),
          ],
        );
      },
    );
  }
}
