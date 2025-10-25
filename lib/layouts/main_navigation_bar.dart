import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:visio_fit/pages/main/camera_page.dart';
import 'package:visio_fit/pages/main/favourites_page.dart';
import 'package:visio_fit/pages/main/glasses_screen.dart';
import 'package:visio_fit/pages/main/profile_page.dart';
import 'package:visio_fit/utils/theme.dart';

class MainNavigationBar extends StatefulWidget {
  final int initialIndex;
  final String faceShapeFilter;
  const MainNavigationBar(
      {super.key, this.initialIndex = 0, required this.faceShapeFilter});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  late int _currentIndex;
  List<String> favoriteIds = [];
  List<Map<String, dynamic>> allGlasses = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void toggleFavorite(String id) {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
  }

  void handleGlassesLoaded(List<Map<String, dynamic>> glasses) {
    setState(() {
      allGlasses = glasses;
    });
  }

  List<Widget> get _pages => [
        CameraPage(),
        GlassesScreen(
          faceShapeFilter: widget.faceShapeFilter,
          favoriteIds: favoriteIds,
          onGlassesLoaded: handleGlassesLoaded,
          toggleFavorite: toggleFavorite,
        ),
        FavoritesScreen(
          allGlasses: allGlasses,
          favoriteIds: favoriteIds,
          toggleFavorite: toggleFavorite,
        ),
        ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppTheme.primaryColor,
        buttonBackgroundColor: AppTheme.primaryColor,
        height: 60,
        index: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CameraPage()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          Icon(Icons.camera, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite_border, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}
