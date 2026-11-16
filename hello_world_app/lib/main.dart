import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routes/app_router.dart';
import 'core/supabase/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSupabaseClient().initialize();
  runApp(const ProviderScope(child: HelloWorldApp()));
}

class HelloWorldApp extends ConsumerWidget {
  const HelloWorldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Pag8',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

