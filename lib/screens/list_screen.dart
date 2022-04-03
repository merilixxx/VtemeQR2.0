// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vtemeqr/bloc/list_screen_bloc.dart';
import 'package:vtemeqr/model/list_screen_bloc_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final dateController = TextEditingController();
  final bloc = GetIt.instance.get<ListScreenBloc>();
  final firebase = FirebaseDatabase(
          databaseURL:
              "https://qrvteme-default-rtdb.europe-west1.firebasedatabase.app")
      .reference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListScreenBloc, ListScreenBlocState>(
      bloc: bloc,
      builder: (context, state) {
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
                      await bloc.getData();
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
                      DateTime.now(),
                    ),
                  ),
          ),
          body: FirebaseAnimatedList(
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              final values = Map<String, dynamic>.from(
                (snapshot.value as Map<dynamic, dynamic>),
              );
              final listOfUsers = <ListTile>[];
              values.forEach((key, value) {
                final user = Map<String, dynamic>.from(value);
                final userTile = ListTile(
                  title: Text(
                    user['Nick'],
                  ),
                  subtitle: Text(
                    user['Name'],
                  ),
                );
                listOfUsers.add(userTile);
              });
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: listOfUsers,
              );
            },
            query: firebase,
          ),
        );
      },
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
          dateController.text = DateFormat('d.M.y').format(picked);
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
