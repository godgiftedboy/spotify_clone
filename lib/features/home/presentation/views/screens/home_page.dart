import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/features/home/presentation/views/screens/pages/user_profile_page.dart';
import 'package:spotify/features/home/presentation/views/widgets/music_stab.dart';

import '../../../../../core/pallete.dart';
import 'pages/library_page.dart';
import 'pages/songs_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;

  final pages = const [
    SongsPage(),
    LibraryPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              color: selectedIndex == 0
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_add,
              color: selectedIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: selectedIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
