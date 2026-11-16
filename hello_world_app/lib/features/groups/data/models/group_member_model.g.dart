import 'package:json_annotation/json_annotation.dart';

part of 'group_member_model.dart';

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) {
  return GroupMemberModel(
    id: json['id'] as String,
    groupId: json['group_id'] as String,
    userId: json['user_id'] as String,
    joinedAt: DateTime.parse(json['joined_at'] as String),
  );
}

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) {
  return <String, dynamic>{
    'id': instance.id,
    'group_id': instance.groupId,
    'user_id': instance.userId,
    'joined_at': instance.joinedAt.toIso8601String(),
  };
}