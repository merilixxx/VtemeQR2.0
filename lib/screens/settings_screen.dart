import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vtemeqr/bloc/list_screen_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bloc = GetIt.instance.get<ListScreenBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: const Text(
              'Настройка списка VIP',
            ),
            leading: Image.asset(
              'assets/images/vip.png',
              width: 32,
              height: 32,
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              'Настройка оплаты',
            ),
            leading: Image.asset(
              'assets/images/money.png',
              width: 32,
              height: 32,
            ),
            onTap: () => bloc.getData(),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 179, 91, 1),
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
      ),
    );
  }
}
