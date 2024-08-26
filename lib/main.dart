import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/theme.dart';
import 'package:spotify/features/auth/presentation/logic/auth_controller.dart';
import 'package:spotify/features/auth/presentation/views/screens/login_page.dart';
import 'package:spotify/features/auth/presentation/views/screens/signup_page.dart';
import 'package:spotify/features/home/presentation/views/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authControllerProvider.notifier).initSharedPreferences();
  await container.read(authControllerProvider.notifier).checkLogin();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider);

    return MaterialApp(
      title: 'Spotify Clone',
      theme: AppTheme.darkThemeMode,
      home: auth.when(data: (data) {
        return data.when(
            loggedIn: () => const HomePage(),
            loggedOut: () => const LoginPage(),
            loading: () => const SignupPage());
      }, error: (error, st) {
        return Material(
          child: Center(
            child: Text(error.toString()),
          ),
        );
      }, loading: () {
        return const CircularProgressIndicator();
      }),
    );
  }
}
