import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

/// Modelo imutável de despesa com serialização JSON.
@JsonSerializable()
class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.groupId,
    required this.title,
    required this.amount,
    required this.paidByUserId,
    required this.category,
    required this.splitWithUserIds,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  final String id;
  final String groupId;
  final String title;
  final double amount;
  final String paidByUserId;
  final String category;
  final List<String> splitWithUserIds;
  final DateTime createdAt;

  ExpenseModel copyWith({
    String? title,
    double? amount,
    String? paidByUserId,
    String? category,
    List<String>? splitWithUserIds,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id,
      groupId: groupId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      paidByUserId: paidByUserId ?? this.paidByUserId,
      category: category ?? this.category,
      splitWithUserIds: splitWithUserIds ?? this.splitWithUserIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
