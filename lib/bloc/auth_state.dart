enum AuthStatus { unauthenticated, authenticated, failure }

class AuthState {
  const AuthState({required this.status, this.errorMessage});

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      errorMessage = null;

  const AuthState.authenticated()
    : status = AuthStatus.authenticated,
      errorMessage = null;

  const AuthState.failure(String message)
    : status = AuthStatus.failure,
      errorMessage = message;

  final AuthStatus status;
  final String? errorMessage;
}
