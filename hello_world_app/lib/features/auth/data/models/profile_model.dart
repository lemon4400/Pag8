import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

/// Modelo imutável de perfil de utilizador com serialização JSON.
@JsonSerializable()
class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  ProfileModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
