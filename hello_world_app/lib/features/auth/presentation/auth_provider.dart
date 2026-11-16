import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/profile_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';

/// Provider do repositório de autenticação.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provider do utilizador atualmente autenticado (ou `null` se não houver sessão).
/// Emite o valor atualizado sempre que o estado de autenticação altera.
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Provider do perfil do utilizador atualmente autenticado.
/// Depende do [currentUserProvider] para obter o userId e buscar na tabela `profiles`.
final profileProvider = FutureProvider<ProfileModel?>((ref) async {
  final currentUserAsync = ref.watch(currentUserProvider);
  final currentUser = currentUserAsync.asData?.value;
  if (currentUser == null) return null;

  final repo = ref.watch(authRepositoryProvider);
  return repo.getProfile(currentUser.id);
});
