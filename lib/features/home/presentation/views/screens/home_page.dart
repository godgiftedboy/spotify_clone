import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/features/auth/presentation/logic/auth_controller.dart';
import 'package:spotify/features/auth/presentation/views/widgets/gradient_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AuthGradientButton(
            buttonText: "Logout",
            onTap: () {
              ref.watch(authControllerProvider.notifier).logout(context);
            }),
      ),
    );
  }
}
