import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/auth_provider.dart';
import 'group_providers.dart';

/// Ecrã para criar um novo grupo (Tarefa 3.2).
class CreateGroupScreen extends ConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _CreateGroupForm();
  }
}

class _CreateGroupForm extends StatefulWidget {
  const _CreateGroupForm();

  @override
  State<_CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<_CreateGroupForm> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createGroup(WidgetRef ref) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira o nome do grupo.')),
        );
      }
      return;
    }
    if (name.length > 50) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O nome do grupo é demasiado longo (máx. 50 caracteres).')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider).asData?.value;
      if (user == null) throw Exception('Utilizador não autenticado.');

      final repo = ref.read(groupRepositoryProvider);
      final groupId = await repo.createGroup(
        name: name,
        createdByUserId: user.id,
      );

      if (mounted) context.pop();
      if (mounted) context.go('/groups/$groupId');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar grupo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Criar Grupo'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Nome do Grupo',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Casa dos Amigos',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 24),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _createGroup(ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Criar Grupo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}