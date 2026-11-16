import 'package:json_annotation/json_annotation.dart';

part of 'profile_model.dart';

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    avatarUrl: json['avatar_url'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) {
  return <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'email': instance.email,
    'avatar_url': instance.avatarUrl,
    'created_at': instance.createdAt.toIso8601String(),
  };
}