import 'package:flutter/material.dart';

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
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    Alignment.topLeft;
                    return TextButton(
                      child: const Text("Настройка списка VIP"),
                      onPressed: () {},
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Builder(
                  builder: (BuildContext context) {
                    Alignment.topLeft;
                    return TextButton(
                      child: const Text("Настройка списка VIP"),
                      onPressed: () {},
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Stack(
              alignment: AlignmentDirectional.topStart,
            ),
          )
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
