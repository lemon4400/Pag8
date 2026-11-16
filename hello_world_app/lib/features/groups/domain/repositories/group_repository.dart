import '../../data/models/group_model.dart';

/// Contrato do repositório de grupos.
abstract class GroupRepository {
  /// Stream de grupos ativos (não fechados) a que o utilizador pertence.
  Stream<List<GroupModel>> get activeGroups;

  /// Stream de grupos fechados a que o utilizador pertence.
  Stream<List<GroupModel>> get closedGroups;

  /// Cria um novo grupo e adiciona o utilizador como primeiro membro.
  Future<String> createGroup({
    required String name,
    required String createdByUserId,
  });

  /// Adiciona um utilizador a um grupo pelo código de 6 dígitos.
  Future<void> joinGroupByCode({
    required String code,
    required String userId,
  });

  /// Busca um grupo pelo seu código alfanumérico.
  Future<GroupModel?> getGroupByCode(String code);
}
