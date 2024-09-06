import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/pallete.dart';
import 'package:spotify/core/providers/current_song_provider.dart';
import 'package:spotify/features/home/presentation/logic/home_controller.dart';
import 'package:spotify/features/home/presentation/views/screens/upload_song_page.dart';

import '../../../../../auth/presentation/views/widgets/gradient_button.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Latest Today",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ref.watch(homeControllerProvider).when(data: (songs) {
            return Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return GestureDetector(
                    onTap: () {
                      ref.read(currentSongProvider.notifier).addSong(song);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    song.thumbnail_url,
                                  ),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 180,
                            child: Text(
                              song.song_name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              song.artist,
                              style: const TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }, error: (error, st) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
          AuthGradientButton(
            buttonText: "Upload Song",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadSongPage()));
            },
          ),
        ],
      ),
    );
  }
}
