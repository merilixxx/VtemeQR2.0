// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_screen_bloc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      name: json['name'] as String,
      nick: json['nick'] as String,
      pay: json['pay'] as int,
      status: json['status'] as String,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'name': instance.name,
      'nick': instance.nick,
      'pay': instance.pay,
      'status': instance.status,
    };
