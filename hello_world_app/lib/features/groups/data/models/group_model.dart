import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

/// Modelo imutável de grupo com serialização JSON.
@JsonSerializable()
class GroupModel {
  const GroupModel({
    required this.id,
    required this.name,
    required this.code,
    required this.isClosed,
    required this.createdBy,
    required this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  final String id;
  final String name;
  final String code;
  @JsonKey(name: 'is_closed')
  final bool isClosed;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  GroupModel copyWith({
    String? name,
    String? code,
    bool? isClosed,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return GroupModel(
      id: id,
      name: name ?? this.name,
      code: code ?? this.code,
      isClosed: isClosed ?? this.isClosed,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
