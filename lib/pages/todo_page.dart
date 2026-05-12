import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitTodo(BuildContext context) {
    context.read<TodoBloc>().add(TodoAdded(_controller.text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo BLoC'),
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state.completedCount == 0
                    ? null
                    : () => context.read<TodoBloc>().add(
                        const CompletedTodosCleared(),
                      ),
                child: const Text('Clear done'),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      onSubmitted: (_) => _submitTodo(context),
                      decoration: const InputDecoration(
                        labelText: 'New task',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _submitTodo(context),
                        child: const Text('Add task'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              BlocConsumer<TodoBloc, TodoState>(
                listenWhen: (previous, current) =>
                    previous.errorMessage != current.errorMessage &&
                    current.errorMessage != null,
                listener: (context, state) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                },
                builder: (context, state) {
                  if (state.status == TodoStatus.loading) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _SummaryChip(
                              label: 'Pending',
                              count: state.pendingCount,
                            ),
                            const SizedBox(width: 8),
                            _SummaryChip(
                              label: 'Done',
                              count: state.completedCount,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: state.todos.isEmpty
                              ? const _EmptyState()
                              : ListView.separated(
                                  itemCount: state.todos.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final todo = state.todos[index];

                                    return Card(
                                      child: ListTile(
                                        leading: Checkbox(
                                          value: todo.isDone,
                                          onChanged: (_) {
                                            context.read<TodoBloc>().add(
                                              TodoToggled(todo.id),
                                            );
                                          },
                                        ),
                                        title: Text(
                                          todo.title,
                                          style: TextStyle(
                                            decoration: todo.isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                        subtitle: Text(
                                          todo.isDone
                                              ? 'Completed'
                                              : 'In progress',
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          onPressed: () {
                                            context.read<TodoBloc>().add(
                                              TodoDeleted(todo.id),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $count'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'No tasks yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text('Add a task and it will be stored for the next launch.'),
        ],
      ),
    );
  }
}
