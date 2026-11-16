import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';

/// Implementação do [AuthRepository] utilizando Supabase Auth.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  SupabaseClient get _client => AppSupabaseClient().client;

  @override
  UserModel? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _toUserModel(user);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return _toUserModel(user);
    });
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    // O trigger `on_auth_user_created` no Supabase cuida de inserir na tabela `profiles`.
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;

    return ProfileModel.fromJson(response);
  }

  @override
  Future<void> upsertProfile(ProfileModel profile) async {
    await _client.from('profiles').upsert(profile.toJson());
  }

  UserModel _toUserModel(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] ?? '',
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }
}
