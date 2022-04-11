import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vtemeqr/bloc/settings_screen_bloc.dart';
import 'package:vtemeqr/model/settings_screen_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => const PricePopUp(),
            ),
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

class PricePopUp extends StatefulWidget {
  const PricePopUp({Key? key}) : super(key: key);

  @override
  State<PricePopUp> createState() => _PricePopUpState();
}

class _PricePopUpState extends State<PricePopUp> {
  final priceVIP = TextEditingController();
  final priceFriend = TextEditingController();
  final priceGuest = TextEditingController();
  final bloc = GetIt.instance.get<SettingsScreenBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsScreenBloc, SettingsScreenBlocState>(
      bloc: bloc,
      builder: (context, state) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'VIP',
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: priceVIP,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: state.priceVIP.toString(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Почетный гость',
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: priceFriend,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: state.priceFriend.toString(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Новичек',
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: priceGuest,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: state.priceGuest.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                _saveChanges();
                Navigator.pop(context);
              },
              child: const Text(
                'Закрыть и сохранить',
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    bloc.setValue(
      'VIP',
      int.parse(
        priceVIP.text,
      ),
    );
    bloc.setValue(
      'Friend',
      int.parse(
        priceFriend.text,
      ),
    );
    bloc.setValue(
      'Guest',
      int.parse(
        priceGuest.text,
      ),
    );
  }
}
