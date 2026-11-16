import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/auth_provider.dart';
import 'group_providers.dart';

/// Ecrã para juntar-se a um grupo por código.
class JoinGroupScreen extends ConsumerWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _JoinGroupForm();
  }
}

class _JoinGroupForm extends StatefulWidget {
  const _JoinGroupForm();

  @override
  State<_JoinGroupForm> createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<_JoinGroupForm> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup(WidgetRef ref) async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty || code.length != 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira um código de 6 dígitos.')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider).asData?.value;
      if (user == null) throw Exception('Utilizador não autenticado.');

      final repo = ref.read(groupRepositoryProvider);
      await repo.joinGroupByCode(code: code, userId: user.id);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
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
            title: const Text('Juntar-se a Grupo'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Código do Grupo',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _codeController,
                  maxLength: 6,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Ex: A7X92B',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 24),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _joinGroup(ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Juntar-se'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}