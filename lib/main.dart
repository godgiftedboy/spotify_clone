import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/theme.dart';
import 'package:spotify/features/auth/presentation/logic/auth_controller.dart';
import 'package:spotify/features/auth/presentation/views/screens/login_page.dart';
import 'package:spotify/features/home/presentation/views/screens/home_page.dart';
import 'package:spotify/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: MaterialApp(
        title: 'Spotify Clone',
        theme: AppTheme.darkThemeMode,
        home: auth.when(
          loggedIn: () => const HomePage(),
          loggedOut: () => const LoginPage(),

          //Loading state created to return
          //from build function in AuthController

          //also used for displaying circular progress indicator instead of button
          //while doing post method in login and signup

          loading: () => const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
