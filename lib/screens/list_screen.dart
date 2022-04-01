import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final dateController = TextEditingController();

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
                onPressed: () => _selectDate(context),
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
