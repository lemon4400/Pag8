import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/login_register_screen.dart';
import '../../features/groups/presentation/create_group_screen.dart';
import '../../features/groups/presentation/group_detail_screen.dart';
import '../../features/groups/presentation/join_group_screen.dart';
import '../../features/home/presentation/home_page.dart';

/// Provider do GoRouter com redirect guard de autenticação.
final goRouterProvider = Provider<GoRouter>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = currentUser.asData?.value != null;
      final isLoginPage = state.uri.path == '/login';

      if (!isAuthenticated && !isLoginPage) {
        return '/login';
      }
      if (isAuthenticated && isLoginPage) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginRegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/groups/create',
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: '/groups/join',
        builder: (context, state) => const JoinGroupScreen(),
      ),
      GoRoute(
        path: '/groups/:id',
        builder: (context, state) => const GroupDetailScreen(),
      ),
    ],
  );
});
