// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vtemeqr/bloc/qr_screen_bloc.dart';
import '../services/fonts.dart';

final addingBloc = GetIt.I.get<QrScreenBloc>();
DateTime data = DateTime.now();
List<Widget> listOfUsers = <Widget>[];
int payment = 0;
int numberOfGuests = 0;

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final dateController = TextEditingController();
  Future<DataSnapshot> firebase = FirebaseDatabase(
          databaseURL:
              "https://qrvteme-default-rtdb.europe-west1.firebasedatabase.app")
      .reference()
      .child('Orders/${DateFormat('d_M_y').format(data).toString()}')
      .get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Image.asset("assets/images/calendar.png",
                    width: 32, height: 32),
                tooltip: 'Выбор даты',
                onPressed: () async {
                  _selectDate(context);
                },
              );
            },
          ),
        ],
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
        title: dateController.text.isNotEmpty
            ? Text(
                dateController.text,
              )
            : Text(
                DateFormat('d.M.y').format(
                  data,
                ),
                style: Font.cuprumStyle20,
              ),
      ),
      body: FutureBuilder(
        future: firebase,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.value != null) {
            final values = Map<String, dynamic>.from(
              (snapshot.data.value as Map<dynamic, dynamic>),
            );
            values.forEach(
              (key, value) {
                final user = Map<String, dynamic>.from(value);
                numberOfGuests++;
                payment += int.parse(
                  user["Pay"],
                );
                final userTile = ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => PopUpEdit(
                        name: user['Name'],
                        nick: '${user["Nick"]}',
                        status: user["Status"],
                        pay: user["Pay"],
                        refresh: () => refreshData(data),
                      ),
                    );
                  },
                  title: Text(
                    'г-н(жа) ${user["Nick"]}',
                    style: Font.cuprumStyle20,
                  ),
                  subtitle: Text(
                    '${user['Name']}',
                    style: Font.cuprumStyle16grey,
                  ),
                  trailing: Text(
                    user["Status"],
                    style: Font.cuprumStyle20,
                  ),
                );
                listOfUsers.add(userTile);
                listOfUsers.add(const Divider(
                  height: 5,
                  color: Colors.grey,
                ));
              },
            );
            return Scaffold(
              backgroundColor: const Color.fromRGBO(255, 179, 91, 1),
              body: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: listOfUsers,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            'Оплачено:',
                            style: Font.cuprumStyle20,
                          ),
                          trailing: Text(
                            '${payment.toString()} BYN',
                            style: Font.cuprumStyle20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            'Гостей:',
                            style: Font.cuprumStyle20,
                          ),
                          trailing: Text(
                            '$numberOfGuests',
                            style: Font.cuprumStyle20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Нет данных для отображения',
                style: Font.cuprumStyle20,
              ),
            );
          }
        },
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1, DateTime.now().month),
      lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month + 5),
    );
    if (picked != null) {
      refreshData(picked);
    }
  }

  void refreshData(DateTime picked) {
    setState(
      () {
        data = picked;
        numberOfGuests = 0;
        payment = 0;
        listOfUsers = <Widget>[];
        firebase = FirebaseDatabase(
                databaseURL:
                    "https://qrvteme-default-rtdb.europe-west1.firebasedatabase.app")
            .reference()
            .child('Orders/${DateFormat('d_M_y').format(data).toString()}')
            .get();
      },
    );
  }
}

class PopUpEdit extends StatefulWidget {
  const PopUpEdit(
      {Key? key,
      required this.name,
      required this.nick,
      required this.status,
      required this.pay,
      required this.refresh})
      : super(key: key);
  final String name;
  final String nick;
  final String status;
  final String pay;
  final VoidCallback refresh;

  @override
  State<PopUpEdit> createState() => _PopUpEditState();
}

class _PopUpEditState extends State<PopUpEdit> {
  final payController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              'Изменять можно только оплату',
              style: Font.cuprumStyle20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Имя: '),
                ),
                Expanded(
                  child: Text(
                    widget.name,
                    style: Font.cuprumStyle20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Ник: '),
                ),
                Expanded(
                  child: Text(
                    widget.nick,
                    style: Font.cuprumStyle20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Статус: '),
                ),
                Expanded(
                  child: Text(
                    widget.status,
                    style: Font.cuprumStyle20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Плата: '),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: payController,
                    decoration: InputDecoration(
                      hintText: widget.pay,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (payController.text.isNotEmpty) {
              addingBloc.updateQR(
                widget.name,
                widget.nick,
                widget.status,
                int.parse(payController.text),
              );
            }
            widget.refresh;
            Navigator.of(context).pop();
          },
          child: Text(
            'Обновить',
            style: Font.cuprumStyle16,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Закрыть и не сохранять',
            style: Font.cuprumStyle16,
          ),
        ),
      ],
    );
  }
}
