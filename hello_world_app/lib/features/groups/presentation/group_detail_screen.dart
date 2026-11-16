import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ecrã de detalhe do grupo (placeholder).
/// Será implementado na Tarefa 3.4 e 4.x.
class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupId = GoRouterState.of(context).pathParameters['id'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do Grupo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Grupo: $groupId'),
            const SizedBox(height: 8),
            const Text('Ecrã em construção (Tarefas 3.4 e 4.x)'),
          ],
        ),
      ),
    );
  }
}
