import 'package:flutter/material.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenstate();
}

class _QrScreenstate extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child:
              Image.asset("assets/images/qr_code.png", width: 150, height: 150),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          tooltip: 'Добавить посетителя',
          label: const Text(
            'Добавить',
            textScaleFactor: 2,
          ),
          backgroundColor: Colors.orange,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
            IconButton(
              icon: Image.asset("assets/images/settings_icon.png",
                  width: 32, height: 32),
              tooltip: 'Настройки',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
