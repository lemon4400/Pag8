import '../../data/models/profile_model.dart';
import '../../data/models/user_model.dart';

/// Contrato do repositório de autenticação.
abstract class AuthRepository {
  /// Utilizador atualmente autenticado, ou `null` se não houver sessão ativa.
  UserModel? get currentUser;

  /// Stream que emite sempre que o estado de autenticação altera (login, logout, expiração de sessão).
  Stream<UserModel?> get authStateChanges;

  /// Regista um novo utilizador com e-mail, password e nome.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Autentica um utilizador com e-mail e password.
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Termina a sessão do utilizador atual.
  Future<void> signOut();

  /// Busca o perfil do utilizador pela tabela `profiles`.
  Future<ProfileModel?> getProfile(String userId);

  /// Insere ou atualiza o perfil do utilizador na tabela `profiles`.
  Future<void> upsertProfile(ProfileModel profile);
}
