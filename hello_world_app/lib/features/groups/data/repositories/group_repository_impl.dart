import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/group_member_model.dart';
import '../../data/models/group_model.dart';
import '../../domain/repositories/group_repository.dart';

/// Implementação do [GroupRepository] utilizando Supabase.
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl();

  SupabaseClient get _client => AppSupabaseClient().client;

  @override
  Stream<List<GroupModel>> get activeGroups {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();

    return _client
        .from('group_members')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((members) async {
          if (members.isEmpty) return <GroupModel>[];

          final groupIds = members
              .map((m) => m['group_id'] as String)
              .toSet();

          final groups = await _client
              .from('groups')
              .select()
              .inFilter('id', groupIds.toList())
              .eq('is_closed', false)
              .order('created_at', ascending: false);

          return groups
              .map((g) => GroupModel.fromJson(g as Map<String, dynamic>))
              .toList();
        });
  }

  @override
  Stream<List<GroupModel>> get closedGroups {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();

    return _client
        .from('group_members')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((members) async {
          if (members.isEmpty) return <GroupModel>[];

          final groupIds = members
              .map((m) => m['group_id'] as String)
              .toSet();

          final groups = await _client
              .from('groups')
              .select()
              .inFilter('id', groupIds.toList())
              .eq('is_closed', true)
              .order('created_at', ascending: false);

          return groups
              .map((g) => GroupModel.fromJson(g as Map<String, dynamic>))
              .toList();
        });
  }

  @override
  Future<String> createGroup({
    required String name,
    required String createdByUserId,
  }) async {
    final code = _generateCode();
    final id = const Uuid().v4();

    await _client.from('groups').insert({
      'id': id,
      'name': name,
      'code': code,
      'is_closed': false,
      'created_by': createdByUserId,
      'created_at': DateTime.now().toIso8601String(),
    });

    await _client.from('group_members').insert({
      'id': const Uuid().v4(),
      'group_id': id,
      'user_id': createdByUserId,
      'joined_at': DateTime.now().toIso8601String(),
    });

    return id;
  }

  @override
  Future<void> joinGroupByCode({
    required String code,
    required String userId,
  }) async {
    final group = await _client
        .from('groups')
        .select()
        .eq('code', code)
        .maybeSingle();

    if (group == null) {
      throw Exception('Código de grupo não encontrado.');
    }

    final groupId = group['id'] as String;

    // Verificar se o utilizador já é membro
    final existing = await _client
        .from('group_members')
        .select()
        .eq('group_id', groupId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing != null) {
      throw Exception('Já é membro deste grupo.');
    }

    await _client.from('group_members').insert({
      'id': const Uuid().v4(),
      'group_id': groupId,
      'user_id': userId,
      'joined_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<GroupModel?> getGroupByCode(String code) async {
    final group = await _client
        .from('groups')
        .select()
        .eq('code', code)
        .maybeSingle();

    if (group == null) return null;

    return GroupModel.fromJson(group as Map<String, dynamic>);
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }
}

