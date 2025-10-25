import 'package:flutter/material.dart';
import 'package:visio_fit/pages/main/comfyu%C4%B1_page.dart';
import 'package:visio_fit/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class GlassDetail extends StatelessWidget {
  final Map<String, dynamic> glass;

  GlassDetail({required this.glass});

  String _simplifyAmazonUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('amazon.com')) {
        // Amazon ürün ID'sini al (dp/ sonrası)
        final dpIndex = url.indexOf('/dp/');
        if (dpIndex != -1) {
          final endIndex = url.indexOf('/', dpIndex + 4);
          final productId = url.substring(
              dpIndex + 4, endIndex != -1 ? endIndex : url.length);
          return 'https://www.amazon.com/dp/$productId';
        }
      }
      return url;
    } catch (e) {
      print('URL sadeleştirme hatası: $e');
      return url;
    }
  }

  Future<void> _launchPurchaseUrl(BuildContext context) async {
    final String? purchaseUrl = glass['purchaseLink'];
    if (purchaseUrl != null && purchaseUrl.isNotEmpty) {
      try {
        final String simplifiedUrl = _simplifyAmazonUrl(purchaseUrl).trim();
        print('Orijinal URL: $purchaseUrl');
        print('Sadeleştirilmiş URL: $simplifiedUrl');

        final Uri uri = Uri.parse(simplifiedUrl);

        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw 'URL açılamadı: $uri';
        }
      } catch (e) {
        print('URL açma hatası detayı: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Satın alma sayfası açılırken bir hata oluştu. Lütfen daha sonra tekrar deneyin.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Kapat',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bu ürün için satın alma linki bulunmuyor.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gözlük Detayı'),
        backgroundColor: Colors.grey[200],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.2),
              AppTheme.accentColor.withOpacity(0.2),
              AppTheme.secondaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Image.network(
                    glass['imageUrl'],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 100, color: Colors.grey);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        glass['name'] ?? 'Bilinmeyen Gözlük',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            "${glass['price'] ?? 'Fiyat Bilinmiyor'} TL",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.face, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            glass['frameShape'] ?? 'Şekil Bilinmiyor',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _launchPurchaseUrl(context),
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Satın Al'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.secondaryColor.withOpacity(0.7),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {/* 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComfyUI(
                                glassesImageUrl: glass['imageUrl'],
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Dene butonuna basıldı, işlem yapılıyor...'),
                              backgroundColor: Colors.blue,
                              duration: Duration(seconds: 2),
                            ),
                          ); */
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Bu özellik henüz geliştirilmedi. Çok yakında sizlerle buluşacağız.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: AppTheme.accentColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.face),
                        label: const Text('Dene'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.accentColor.withOpacity(0.7),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
