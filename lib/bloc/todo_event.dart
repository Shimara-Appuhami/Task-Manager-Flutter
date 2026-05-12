abstract class TodoEvent {
  const TodoEvent();
}

class TodoStarted extends TodoEvent {
  const TodoStarted();
}

class TodoAdded extends TodoEvent {
  const TodoAdded(this.title);

  final String title;
}

class TodoToggled extends TodoEvent {
  const TodoToggled(this.id);

  final String id;
}

class TodoDeleted extends TodoEvent {
  const TodoDeleted(this.id);

  final String id;
}

class CompletedTodosCleared extends TodoEvent {
  const CompletedTodosCleared();
}
