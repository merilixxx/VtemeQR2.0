// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);
import 'dart:convert';

Map<String, Users> usersFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Users>(k, Users.fromJson(v)));

String usersToJson(Map<String, Users> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

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

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        name: json["Name"],
        nick: json["Nick"],
        pay: json["Pay"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Nick": nick,
        "Pay": pay,
        "Status": status,
      };
}
