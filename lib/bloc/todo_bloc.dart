import 'package:bloc/bloc.dart';

import '../models/todo_item.dart';
import '../storage/todo_storage.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._storage) : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<TodoAdded>(_onAdded);
    on<TodoToggled>(_onToggled);
    on<TodoDeleted>(_onDeleted);
    on<CompletedTodosCleared>(_onClearedCompleted);
  }

  final TodoStorage _storage;

  Future<void> _onStarted(TodoStarted event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading, errorMessage: null));

    try {
      final todos = await _storage.loadTodos();
      emit(state.copyWith(status: TodoStatus.loaded, todos: todos));
    } catch (_) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to load saved tasks.',
        ),
      );
    }
  }

  Future<void> _onAdded(TodoAdded event, Emitter<TodoState> emit) async {
    final title = event.title.trim();
    if (title.isEmpty) {
      return;
    }

    final updated = List<TodoItem>.from(state.todos)
      ..add(
        TodoItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
        ),
      );

    await _persist(emit, updated);
  }

  Future<void> _onToggled(TodoToggled event, Emitter<TodoState> emit) async {
    final updated = state.todos
        .map(
          (todo) =>
              todo.id == event.id ? todo.copyWith(isDone: !todo.isDone) : todo,
        )
        .toList(growable: false);

    await _persist(emit, updated);
  }

  Future<void> _onDeleted(TodoDeleted event, Emitter<TodoState> emit) async {
    final updated = state.todos
        .where((todo) => todo.id != event.id)
        .toList(growable: false);

    await _persist(emit, updated);
  }

  Future<void> _onClearedCompleted(
    CompletedTodosCleared event,
    Emitter<TodoState> emit,
  ) async {
    final updated = state.todos
        .where((todo) => !todo.isDone)
        .toList(growable: false);

    await _persist(emit, updated);
  }

  Future<void> _persist(Emitter<TodoState> emit, List<TodoItem> todos) async {
    try {
      await _storage.saveTodos(todos);
      emit(
        state.copyWith(
          status: TodoStatus.loaded,
          todos: todos,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to save tasks.',
        ),
      );
    }
  }
}
