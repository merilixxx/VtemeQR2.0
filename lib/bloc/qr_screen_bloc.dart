import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/qr_screen_bloc_model.dart';

class QrScreenBloc extends Cubit<QrScreenBlocState> {
  QrScreenBloc(QrScreenBlocState initialState) : super(initialState);

  Future addQR(name, nick, status) async {
    print(DateFormat('d_M_y').format(DateTime.now()));
    final prefs = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    final firebase = FirebaseDatabase(
            databaseURL:
                "https://qrvteme-default-rtdb.europe-west1.firebasedatabase.app")
        // ignore: deprecated_member_use
        .reference();
    final pay;
    switch (status) {
      case 'VIP':
        pay = prefs.getInt('VIP');
        break;
      case 'Гость Клуба':
        pay = prefs.getInt('Guest');
        break;
      case 'Друг Клуба':
        pay = prefs.getInt('Friend');
        break;
      default:
        pay = prefs.getInt('Guest');
    }
    await firebase.set({
      "01_01_01": {
        "$name": {
          "Name": "$name",
          "Nick": "$nick",
          "Pay": "$pay",
          "Status": "$status"
        }
      }
    });
  }
}
