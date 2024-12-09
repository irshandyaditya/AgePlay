import 'package:age_play/pages/bookmark.dart';
import 'package:age_play/pages/home_page.dart';
import 'package:age_play/pages/profile.dart';
import 'package:age_play/pages/search.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBarWidget({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3), // Warna shadow
            spreadRadius: 2,
            blurRadius: 10, // Semakin tinggi blur, semakin lembut shadow
            offset: Offset(0, -4), // Offset ke atas
          ),
        ],
      ),
      child: SizedBox(
        height: 55, // Sesuaikan tinggi navbar di sini
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_outlined,
                color: currentIndex == 0 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                    transitionDuration: Duration.zero, // Durasi transisi 0
                    reverseTransitionDuration: Duration.zero, // Durasi transisi balik 0
                  ),
                );
                onTap(0);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.explore_outlined,
                color: currentIndex == 1 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                    transitionDuration: Duration.zero, // Durasi transisi 0
                    reverseTransitionDuration: Duration.zero, // Durasi transisi balik 0
                  ),
                );
                onTap(1);
              },
            ),
            SizedBox(width: 50), // Tambahkan jarak di antara Search dan Bookmark
            IconButton(
              icon: Icon(
                Icons.bookmarks_outlined,
                color: currentIndex == 2 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => BookmarkPage(),
                    transitionDuration: Duration.zero, // Durasi transisi 0
                    reverseTransitionDuration: Duration.zero, // Durasi transisi balik 0
                  ),
                );
                onTap(2);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_outline_rounded,
                color: currentIndex == 3 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Profile(),
                    transitionDuration: Duration.zero, // Durasi transisi 0
                    reverseTransitionDuration: Duration.zero, // Durasi transisi balik 0
                  ),
                );
                onTap(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
