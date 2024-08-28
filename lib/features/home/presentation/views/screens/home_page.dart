import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/providers/current_user_provider.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Name: ${ref.watch(currentUserProvider)!.name}"),
          Text("Email: ${ref.watch(currentUserProvider)!.email}"),
          CircleAvatar(
            radius: 50,
            child: ClipOval(
              child: Image.network(
                scale: 0.7,
                ref.watch(currentUserProvider)!.photoUrl,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/images/image_not_found.png');
                },
              ),
            ),
          ),
          AuthGradientButton(
              buttonText: "Logout",
              onTap: () {
                ref.watch(authControllerProvider.notifier).logout(context);
              }),
        ],
      ),
    );
  }
}
