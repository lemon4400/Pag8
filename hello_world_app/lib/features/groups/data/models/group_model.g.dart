import 'package:json_annotation/json_annotation.dart';

part of 'group_model.dart';

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return GroupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    isClosed: json['is_closed'] as bool,
    createdBy: json['created_by'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) {
  return <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'code': instance.code,
    'is_closed': instance.isClosed,
    'created_by': instance.createdBy,
    'created_at': instance.createdAt.toIso8601String(),
  };
}