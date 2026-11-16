import 'package:json_annotation/json_annotation.dart';

part 'group_member_model.g.dart';

/// Modelo imutável de associação entre utilizador e grupo.
@JsonSerializable()
class GroupMemberModel {
  const GroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.joinedAt,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);

  final String id;
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'joined_at')
  final DateTime joinedAt;

  GroupMemberModel copyWith({
    String? id,
    String? groupId,
    String? userId,
    DateTime? joinedAt,
  }) {
    return GroupMemberModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
