import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Modelo imutável de utilizador com serialização JSON.
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  UserModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
