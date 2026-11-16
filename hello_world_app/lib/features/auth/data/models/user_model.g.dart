import 'package:json_annotation/json_annotation.dart';

part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    avatarUrl: json['avatarUrl'] as String?,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  return <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'email': instance.email,
    'avatarUrl': instance.avatarUrl,
  };
}