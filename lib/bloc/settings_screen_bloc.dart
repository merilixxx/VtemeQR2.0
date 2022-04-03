import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/settings_screen_model.dart';

class SettingsScreenBloc extends Cubit<SettingsScreenBlocState> {
  SettingsScreenBloc(SettingsScreenBlocState initialState)
      : super(initialState);

  Future setValue(String value, int price) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(value, price);
    emit(
      SettingsScreenBlocState(
        priceVIP: prefs.getInt('VIP'),
        priceFriend: prefs.getInt('Friend'),
        priceGuest: prefs.getInt('Guest'),
      ),
    );
  }

  Future getvalue() async {
    final prefs = await SharedPreferences.getInstance();
    emit(
      SettingsScreenBlocState(
        priceVIP: prefs.getInt('VIP'),
        priceFriend: prefs.getInt('Friend'),
        priceGuest: prefs.getInt('Guest'),
      ),
    );
  }
}
