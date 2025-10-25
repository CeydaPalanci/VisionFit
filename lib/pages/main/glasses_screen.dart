import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visio_fit/pages/main/favourites_page.dart';
import 'package:visio_fit/pages/main/glasses_detail.dart';
import 'package:visio_fit/services/glasses_service.dart';
import 'package:visio_fit/utils/theme.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class GlassesScreen extends StatefulWidget {
  final String? faceShapeFilter;
  final List<String> favoriteIds;
  final Function(String) toggleFavorite;
  final Function(List<Map<String, dynamic>>) onGlassesLoaded;
  const GlassesScreen(
      {Key? key,
      this.faceShapeFilter,
      required this.favoriteIds,
      required this.onGlassesLoaded,
      required this.toggleFavorite})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<GlassesScreen> {
  List<Map<String, dynamic>> glasses = [];
  List<Map<String, dynamic>> originalFilteredGlassesByFaceShape = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredGlasses = [];
  List<Map<String, dynamic>> filteredGlassesByFaceShape = [];

  final List<Color> shadowColors = [
    Color(0xFF789DBC).withOpacity(0.9), // Mavi
    Color(0xFFFFE3E3).withOpacity(0.9), // Pembe
    Color(0xFFC9E9D2).withOpacity(0.9), // Yeşil
  ];
  List<Map<String, String>> categories = [];
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGlasses();
      _fetchBrands();
      if (widget.faceShapeFilter != null &&
          widget.faceShapeFilter!.isNotEmpty) {
        _fetchGlassesByFaceShape();
      }
      _fetchGlasses().then((_) {
        widget.onGlassesLoaded(glasses); // Ebeveyn'e listeyi ilet
      });
    });
  }

  Future<void> _fetchGlasses() async {
    final glassesService = GlassesService();
    try {
      final fetchedGlasses = await glassesService.fetchGlasses();
      setState(() {
        glasses = fetchedGlasses;
        filteredGlasses = fetchedGlasses;
        isLoading = false;
      });
      widget.onGlassesLoaded(fetchedGlasses);
    } catch (e) {
      print("Hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchGlassesByFaceShape() async {
    final faceShape = widget.faceShapeFilter?.trim().toLowerCase();
    if (faceShape == null || faceShape.isEmpty) {
      print("❌ Yüz şekli boş veya null");
      return;
    }

    final glassesService = GlassesService();
    try {
      print("Flutter'dan gönderilen yüz şekli: '${widget.faceShapeFilter}'");
      print("✅ Filtreye gönderilen yüz şekli: '${widget.faceShapeFilter}'");

      final fetchedGlasses =
          await glassesService.fetchGlassesByFaceShape(faceShape);
      setState(() {
        filteredGlassesByFaceShape = fetchedGlasses;
        originalFilteredGlassesByFaceShape = fetchedGlasses;
        isLoading = false;
      });
    } catch (e) {
      print("Yüz şekline göre gözlük getirme hatası: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchBrands() async {
    final glassesService = GlassesService();
    try {
      final fetchedBrands = await glassesService.fetchBrands();
      setState(() {
        categories = fetchedBrands;
      });
    } catch (e) {
      print("Markalar yüklenemedi: $e");
    }
  }

  void _searchGlasses(String query) {
    final keywords = query.toLowerCase().split(' ');

    List<Map<String, dynamic>> baseList = glasses;
    List<Map<String, dynamic>> baseListByFaceShape =
        originalFilteredGlassesByFaceShape;
    if (selectedBrand != null) {
      baseList = baseList.where((glass) {
        return (glass['brand'] ?? '').toLowerCase() ==
            selectedBrand!.toLowerCase();
      }).toList();
      baseListByFaceShape = baseListByFaceShape.where((glass) {
        return (glass['brand'] ?? '').toLowerCase() ==
            selectedBrand!.toLowerCase();
      }).toList();
    }

    final filtered = baseList.where((glass) {
      final name = (glass['name'] ?? '').toLowerCase();
      final frameShape = (glass['frameShape'] ?? '').toLowerCase();
      return keywords
          .every((kw) => name.contains(kw) || frameShape.contains(kw));
    }).toList();

    final filteredByFaceShape = baseListByFaceShape.where((glass) {
      final name = (glass['name'] ?? '').toLowerCase();
      final frameShape = (glass['frameShape'] ?? '').toLowerCase();
      return keywords
          .every((kw) => name.contains(kw) || frameShape.contains(kw));
    }).toList();

    setState(() {
      filteredGlasses = filtered;
      filteredGlassesByFaceShape = filteredByFaceShape;
    });
  }

  void _filterByBrand(String brand) {
    setState(() {
      if (selectedBrand == brand) {
        selectedBrand = null;
        filteredGlasses = glasses;
        filteredGlassesByFaceShape = originalFilteredGlassesByFaceShape;
        _searchController.clear();
      } else {
        selectedBrand = brand;
        _searchGlasses(_searchController.text);
      }
    });
  }

  final gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppTheme.primaryColor.withOpacity(0.5),
      AppTheme.accentColor.withOpacity(0.5),
      AppTheme.secondaryColor.withOpacity(0.5),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ), */
      
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Ara...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (query) {
                          _searchGlasses(query);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Markalar",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                _filterByBrand(categories[index]['name']!);
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipOval(
                                      child: Image.network(
                                        categories[index]['imageUrl'] ??
                                            'https://via.placeholder.com/70',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print(
                                              'Image loading error for ${categories[index]['name']}: $error');
                                          return Icon(Icons.branding_watermark,
                                              size: 40, color: Colors.grey);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    categories[index]['name']!,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Yüz şekliniz (${widget.faceShapeFilter}) için önerilen gözlükler",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(10),
                        itemCount: filteredGlassesByFaceShape.length,
                        itemBuilder: (context, index) {
                          final glass = filteredGlassesByFaceShape[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GlassDetail(glass: glass),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Card(
                                color: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 10,
                                shadowColor:
                                    shadowColors[index % shadowColors.length],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          color: Colors.white,
                                          child: Image.network(
                                            glass['imageUrl'],
                                            width: double.infinity,
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${glass['price']} TL",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[700]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              widget.favoriteIds.contains(
                                                      glass['id'].toString())
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: AppTheme.primaryColor,
                                            ),
                                            onPressed: () {
                                              widget.toggleFavorite(
                                                  glass['id'].toString());
                                              setState(
                                                  () {}); // Favori durumu değişince UI'yı yenilemek için
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${glass['frameShape']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppTheme.primaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tüm Ürünlerimiz",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(10),
                        itemCount: filteredGlasses.length,
                        itemBuilder: (context, index) {
                          final glass = filteredGlasses[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GlassDetail(glass: glass),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Card(
                                color: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 10,
                                shadowColor:
                                    shadowColors[index % shadowColors.length],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          color: Colors.white,
                                          child: Image.network(
                                            glass['imageUrl'],
                                            width: double.infinity,
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${glass['price']} TL",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[700]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              widget.favoriteIds.contains(
                                                      glass['id'].toString())
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: AppTheme.primaryColor,
                                            ),
                                            onPressed: () {
                                              widget.toggleFavorite(
                                                  glass['id'].toString());
                                              setState(
                                                  () {}); // Favori durumu değişince UI'yı yenilemek için
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${glass['frameShape']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppTheme.primaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
