import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/qr_screen_bloc_model.dart';

class QrScreenBloc extends Cubit<QrScreenBlocState> {
  QrScreenBloc(QrScreenBlocState initialState) : super(initialState);

  Future connectSQL() async {
    //await SqlConn.connect(
    //   ip: "31.130.207.31",
    //   port: "8888",
    //   databaseName: "studi181_mafia-scan",
    //   username: "studi181_mafia-scan",
    //   password: "qwe700700",
    // );
    // print(SqlConn.isConnected);
  }
}
