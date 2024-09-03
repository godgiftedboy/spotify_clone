import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
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
        ],
      ),
    );
  }
}

// Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Name: ${ref.watch(currentUserProvider)!.name}"),
//           Text("Email: ${ref.watch(currentUserProvider)!.email}"),
//           CircleAvatar(
//             radius: 50,
//             child: ClipOval(
//               child: Image.network(
//                 scale: 0.7,
//                 ref.watch(currentUserProvider)!.photoUrl,
//                 fit: BoxFit.contain,
//                 errorBuilder: (BuildContext context, Object exception,
//                     StackTrace? stackTrace) {
//                   return Image.asset('assets/images/image_not_found.png');
//                 },
//               ),
//             ),
//           ),
//           AuthGradientButton(
//             buttonText: "Upload Song",
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const UploadSongPage()));
//             },
//           ),
//           AuthGradientButton(
//             buttonText: "Logout",
//             onTap: () {
//               ref.watch(authControllerProvider.notifier).logout(context);
//             },
//           ),
//         ],
// ),
