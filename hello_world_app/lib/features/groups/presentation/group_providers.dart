import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/group_model.dart';
import '../data/repositories/group_repository_impl.dart';
import '../domain/repositories/group_repository.dart';

/// Provider do repositório de grupos.
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepositoryImpl();
});

/// Stream de grupos ativos a que o utilizador logado pertence.
final activeGroupsProvider = StreamProvider<List<GroupModel>>((ref) {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.activeGroups;
});

/// Stream de grupos fechados a que o utilizador logado pertence.
final closedGroupsProvider = StreamProvider<List<GroupModel>>((ref) {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.closedGroups;
});
