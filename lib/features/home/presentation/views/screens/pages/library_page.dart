import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/pallete.dart';
import 'package:spotify/core/providers/current_song_provider.dart';
import 'package:spotify/features/home/presentation/logic/fav_song_controller.dart';

import '../upload_song_page.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favSongs = ref.watch(favSongControllerProvider);
    return favSongs.when(data: (data) {
      return ListView.builder(
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == data.length) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadSongPage()));
              },
              leading: const CircleAvatar(
                radius: 35,
                backgroundColor: Pallete.backgroundColor,
                child: Icon(Icons.add),
              ),
              title: const Text(
                "Upload Song",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            );
          }
          final song = data[index];
          return ListTile(
            onTap: () {
              ref.read(currentSongProvider.notifier).addSong(song);
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(song.thumbnail_url),
              radius: 35,
              backgroundColor: Pallete.backgroundColor,
            ),
            title: Text(
              song.song_name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              song.artist,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          );
        },
      );
    }, error: (error, st) {
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
