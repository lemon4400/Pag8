import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../groups/data/models/group_model.dart';
import '../../groups/presentation/group_providers.dart';

/// Ecrã Home com lista de grupos ativos e fechados.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGroupsAsync = ref.watch(activeGroupsProvider);
    final closedGroupsAsync = ref.watch(closedGroupsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Grupos'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            _GroupListTab(
              groupsAsync: activeGroupsAsync,
              title: 'Grupos Ativos',
            ),
            _GroupListTab(
              groupsAsync: closedGroupsAsync,
              title: 'Grupos Fechados',
            ),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: 'Ativos', icon: Icon(Icons.group)),
            Tab(text: 'Fechados', icon: Icon(Icons.lock)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showGroupBottomSheet(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showGroupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.create),
            title: const Text('Criar Grupo'),
            onTap: () {
              context.pop();
              context.push('/groups/create');
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Juntar-se a Grupo'),
            onTap: () {
              context.pop();
              context.push('/groups/join');
            },
          ),
        ],
      ),
    );
  }
}

/// Tab de lista de grupos.
class _GroupListTab extends ConsumerWidget {
  final AsyncValue<List<GroupModel>> groupsAsync;
  final String title;

  const _GroupListTab({
    required this.groupsAsync,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  title.contains('Ativos') ? Icons.group : Icons.lock,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum $title',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title.contains('Ativos')
                      ? 'Use o botão + para criar ou juntar-se a um grupo.'
                      : 'Os grupos fechados aparecem aqui.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _GroupCard(group: group);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Erro ao carregar grupos: $error'),
      ),
    );
  }
}

/// Card de grupo na lista.
class _GroupCard extends ConsumerWidget {
  final GroupModel group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple[50],
          child: Icon(Icons.group, color: Colors.deepPurple[700]),
        ),
        title: Text(
          group.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          group.isClosed ? 'Fechado' : 'Ativo • Código: ${group.code}',
          style: TextStyle(
            color: group.isClosed ? Colors.grey[600] : Colors.deepPurple[700],
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.grey),
          onPressed: () => context.push('/groups/${group.id}'),
        ),
      ),
    );
  }
}
