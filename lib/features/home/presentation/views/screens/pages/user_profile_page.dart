import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/current_user_provider.dart';
import '../../../../../auth/presentation/logic/auth_controller.dart';
import '../../../../../auth/presentation/views/widgets/gradient_button.dart';
import '../upload_song_page.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text("Name: ${ref.watch(currentUserProvider)!.name}"),
              Text("Email: ${ref.watch(currentUserProvider)!.email}"),
              const SizedBox(height: 20),
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
            ],
          ),
          Column(
            children: [
              AuthGradientButton(
                buttonText: "Upload Song",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadSongPage()));
                },
              ),
              const SizedBox(height: 15),
              AuthGradientButton(
                buttonText: "Logout",
                onTap: () {
                  ref.watch(authControllerProvider.notifier).logout(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
