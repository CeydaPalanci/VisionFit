import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visio_fit/pages/main/glasses_detail.dart';
import 'package:visio_fit/services/glasses_service.dart';
import 'package:visio_fit/utils/theme.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allGlasses;
  final List<String> favoriteIds;
  final Function(String) toggleFavorite;

  const FavoritesScreen(
      {Key? key,
      required this.allGlasses,
      required this.favoriteIds,
      required this.toggleFavorite})
      : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteGlasses = widget.allGlasses
        .where((glass) => widget.favoriteIds.contains(glass['id'].toString()))
        .toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.4),
              AppTheme.accentColor.withOpacity(0.4),
              AppTheme.secondaryColor.withOpacity(0.4),
            ],
          ),
        ),
        child: favoriteGlasses.isEmpty
            ? Center(
                child: Text(
                  'Henüz favori gözlüğünüz yok.',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: favoriteGlasses.length,
                itemBuilder: (context, index) {
                  final glass = favoriteGlasses[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GlassDetail(glass: glass),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.white,
                                child: Image.network(
                                  glass['imageUrl'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(glass['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 8),
                                        Text(glass['brand'],
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.favorite,
                                        color: AppTheme.primaryColor),
                                    onPressed: () {
                                      widget.toggleFavorite(
                                          glass['id'].toString());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
