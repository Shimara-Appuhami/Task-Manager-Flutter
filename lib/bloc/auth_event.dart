abstract class AuthEvent {
  const AuthEvent();
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.username, required this.password});

  final String username;
  final String password;
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
