import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.unauthenticated()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) {
    if (event.username.trim() == 'admin' && event.password == '1234') {
      emit(const AuthState.authenticated());
      return;
    }

    emit(const AuthState.failure('Invalid username or password.'));
    emit(const AuthState.unauthenticated());
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthState.unauthenticated());
  }
}
