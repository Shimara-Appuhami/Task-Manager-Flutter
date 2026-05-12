import '../models/todo_item.dart';

enum TodoStatus { initial, loading, loaded, failure }

class TodoState {
  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.errorMessage,
  });

  final TodoStatus status;
  final List<TodoItem> todos;
  final String? errorMessage;

  int get completedCount => todos.where((todo) => todo.isDone).length;
  int get pendingCount => todos.where((todo) => !todo.isDone).length;

  TodoState copyWith({
    TodoStatus? status,
    List<TodoItem>? todos,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage,
    );
  }
}
