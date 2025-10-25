import 'package:dio/dio.dart';
import 'dart:io';

import 'package:dio/io.dart';
import 'package:visio_fit/config/app_config.dart';

class GlassesService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  )..httpClientAdapter = _createHttpClientAdapter();

  static HttpClientAdapter _createHttpClientAdapter() {
    return DefaultHttpClientAdapter()
      ..onHttpClientCreate = (HttpClient client) {
        // SSL sertifika doğrulamasını devre dışı bırak
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
  }

  Future<List<Map<String, dynamic>>> fetchGlasses() async {
    try {
      final response = await _dio.get('/api/glasses'); // API'ye istek at
      if (response.statusCode == 200) {
        print(
            'Gözlük API Response: ${response.data}'); // API yanıtını kontrol et
        final List<Map<String, dynamic>> glasses =
            List<Map<String, dynamic>>.from(response.data);

        // Her bir gözlük için satın alma linkini kontrol et
        for (var glass in glasses) {
          print(
              'Gözlük detayı: $glass'); // Her bir gözlüğün verilerini kontrol et
          if (glass['purchaseLink'] == null) {
            print('Uyarı: ${glass['name']} için satın alma linki bulunamadı');
          }
        }

        return glasses;
      } else {
        throw Exception('Failed to load glasses');
      }
    } catch (e) {
      print('Error fetching glasses: $e');
      throw Exception('Error fetching glasses: $e');
    }
  }

  Future<List<Map<String, String>>> fetchBrands() async {
    try {
      final response = await _dio.get('/api/glasses/brands');
      print('Brands API Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('Parsed Brands Data: $data');

        // Benzersiz markaları filtrele
        final uniqueBrands = <String, Map<String, String>>{};
        data.forEach((item) {
          final brandName = item['brand']?.toString() ?? 'Unknown Brand';
          if (!uniqueBrands.containsKey(brandName)) {
            uniqueBrands[brandName] = {
              'name': brandName,
              'imageUrl': item['brandImageUrl']?.toString() ??
                  'https://via.placeholder.com/70',
            };
          }
        });

        return uniqueBrands.values.toList();
      } else {
        throw Exception('Failed to load brands');
      }
    } catch (e) {
      print('Error fetching brands: $e');
      throw Exception('Error fetching brands: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGlassesByFaceShape(
      String faceShape) async {
    try {
      print('İstek atılıyor: $faceShape');
      

      final response = await _dio.get(
        '/api/glasses/by-face-shape/$faceShape',
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> filteredGlasses =
            List<Map<String, dynamic>>.from(response.data);
        print('Filtrelenmiş Gözlükler ($faceShape): $filteredGlasses');
        return filteredGlasses;
      } else {
        throw Exception('Yüz şekli ile gözlük bulunamadı');
      }
    } catch (e) {
      print('Yüz şekline göre gözlük getirme hatası: $e');
      throw Exception('Yüz şekline göre gözlük getirme hatası: $e');
    }

  }
}
