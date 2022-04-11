// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../bloc/settings_screen_bloc.dart';
import '../services/fonts.dart';

final bloc = GetIt.instance.get<SettingsScreenBloc>();
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.values == null) {
            return Center(
              child: Text(
                'Нет данных для отображения',
                style: Font.cuprumStyle20,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
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
}

class ListItem extends StatelessWidget {
  final String from;
  final String to;
  final String name;
  final String paid;
  const ListItem({
    Key? key,
    required this.from,
    required this.to,
    required this.name,
    required this.paid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: TextButton(
        onPressed: () {},
        child: const Icon(
          Icons.star_border_outlined,
        ),
      ),
      leading: const Icon(
        Icons.car_rental,
        size: 30,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '$from - $to   ',
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name.toString(),
          ),
          Text(
            paid != '0' ? '$paid BYN' : 'Безплатно',
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        30,
        10,
        0,
        15,
      ),
    );
  }
}
