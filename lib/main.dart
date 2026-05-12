import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'pages/login_page.dart';
import 'pages/todo_page.dart';
import 'storage/todo_storage.dart';

void main() {
  runApp(MyApp(storage: CookieTodoStorage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.storage});

  final TodoStorage storage;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: storage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(
            create: (_) => TodoBloc(storage)..add(const TodoStarted()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo BLoC App',
          theme: ThemeData(
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFF14532D),
              onPrimary: Colors.white,
              secondary: Color(0xFF0F766E),
              onSecondary: Colors.white,
              error: Color(0xFFB42318),
              onError: Colors.white,
              surface: Color(0xFFF5F7F2),
              onSurface: Color(0xFF142013),
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF5F7F2),
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              backgroundColor: Colors.transparent,
              foregroundColor: Color(0xFF142013),
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.88),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFFD7E0D1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFFD7E0D1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFF14532D),
                  width: 1.4,
                ),
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              color: Colors.white.withValues(alpha: 0.82),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            chipTheme: ChipThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              side: BorderSide.none,
              backgroundColor: Colors.white,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF142013),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF14532D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          home: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const TodoPage();
        }

        return const LoginPage();
      },
    );
  }
}
