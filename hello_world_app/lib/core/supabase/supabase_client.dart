import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_constants.dart';

/// Singleton que expõe o cliente Supabase configurado.
class AppSupabaseClient {
  static final AppSupabaseClient _instance = AppSupabaseClient._internal();

  factory AppSupabaseClient() => _instance;

  AppSupabaseClient._internal();

  /// Inicializa o cliente Supabase. Deve ser chamado antes de `runApp()`.
  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  /// Retorna a instância do cliente Supabase.
  SupabaseClient get client => Supabase.instance.client;
}
