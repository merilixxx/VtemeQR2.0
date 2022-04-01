import 'package:json_annotation/json_annotation.dart';

part 'list_screen_bloc_model.g.dart';

class ListScreenBlocState {
  ListScreenBlocState({
    required this.users,
  });

  final Users users;
}

@JsonSerializable()
class Users {
  Users({
    required this.name,
    required this.nick,
    required this.pay,
    required this.status,
  });

  final String name;
  final String nick;
  final int pay;
  final String status;

  factory Users.fromJson(Map<String, dynamic> json) =>
      _$UsersFromJson(json);
}
