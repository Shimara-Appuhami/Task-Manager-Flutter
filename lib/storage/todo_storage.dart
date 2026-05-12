import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/todo_item.dart';
import 'cookie_backend_stub.dart'
    if (dart.library.html) 'cookie_backend_web.dart'
    as cookie_backend;

abstract class TodoStorage {
  Future<List<TodoItem>> loadTodos();
  Future<void> saveTodos(List<TodoItem> todos);
}

class CookieTodoStorage implements TodoStorage {
  CookieTodoStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _storageKey = 'todo_items';
  final FlutterSecureStorage _secureStorage;

  @override
  Future<List<TodoItem>> loadTodos() async {
    final raw = await _readValue();
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => TodoItem.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<void> saveTodos(List<TodoItem> todos) async {
    final payload = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await _writeValue(payload);
  }

  Future<String?> _readValue() async {
    if (kIsWeb) {
      return _readCookie();
    }

    return _secureStorage.read(key: _storageKey);
  }

  Future<void> _writeValue(String value) async {
    if (kIsWeb) {
      _writeCookie(value);
      return;
    }

    await _secureStorage.write(key: _storageKey, value: value);
  }

  String? _readCookie() {
    final cookies = cookie_backend.readCookieString();
    if (cookies == null || cookies.isEmpty) {
      return null;
    }

    final entries = cookies.split(';');
    for (final entry in entries) {
      final trimmed = entry.trim();
      if (trimmed.startsWith('$_storageKey=')) {
        return Uri.decodeComponent(trimmed.substring(_storageKey.length + 1));
      }
    }

    return null;
  }

  void _writeCookie(String value) {
    final encoded = Uri.encodeComponent(value);
    cookie_backend.writeCookieString(
      '$_storageKey=$encoded; path=/; max-age=31536000; samesite=lax',
    );
  }
}

class MemoryTodoStorage implements TodoStorage {
  MemoryTodoStorage([List<TodoItem>? initialTodos])
    : _todos = List<TodoItem>.from(initialTodos ?? const []);

  List<TodoItem> _todos;

  @override
  Future<List<TodoItem>> loadTodos() async {
    return List<TodoItem>.from(_todos);
  }

  @override
  Future<void> saveTodos(List<TodoItem> todos) async {
    _todos = List<TodoItem>.from(todos);
  }
}
