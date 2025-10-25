import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:visio_fit/layouts/main_navigation_bar.dart';
import 'package:visio_fit/pages/main/camera_page.dart';
import 'package:visio_fit/pages/main/glasses_screen.dart';
import 'package:visio_fit/utils/theme.dart';

class ResultPage extends StatefulWidget {
  final String imagePath;

  const ResultPage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? resultImagePath;
  String? faceShapeResult;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    //_sendToServer(widget.imagePath);
    //_processImage();
    // Test için sadece loading'i false yap
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> _processImage() async {
  //   try {
  //     String imagePath = widget.imagePath;

  //     // Eğer asset'ten bir görüntü ise, önce onu geçici bir dosyaya kopyala
  //     if (imagePath.startsWith('assets/')) {
  //       final ByteData data = await rootBundle.load(imagePath);
  //       final Directory tempDir = await getTemporaryDirectory();

  //       final String uniqueName = const Uuid().v4();
  //       final String tempPath = '${tempDir.path}/temp_$uniqueName.jpg';

  //       final File tempFile = File(tempPath);
  //       await tempFile.writeAsBytes(data.buffer.asUint8List());
  //       imagePath = tempPath;
  //     }

  //     await _sendToRapidAPI(imagePath);
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Görüntü işlenirken hata oluştu: $e';
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _sendToRapidAPI(String imagePath) async {
  //   try {
  //     // Görseli oku ve base64'e çevir
  //     final bytes = await File(imagePath).readAsBytes();
  //     final base64Image = base64Encode(bytes);

  //     final uri =
  //         Uri.parse("https://detect-face-shape.p.rapidapi.com/api/predict");

  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'X-RapidAPI-Key':
  //             '97c9d41a58mshe8ebe79de1464ccp1249bajsn940743fa1322',
  //         'X-RapidAPI-Host': 'detect-face-shape.p.rapidapi.com',
  //       },
  //       body: jsonEncode({
  //         'image': base64Image,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       final shape = (jsonResponse['results'][0]['shape'] ?? "")
  //           .toString()
  //           .toLowerCase()
  //           .trim();

  //       setState(() {
  //         faceShapeResult = shape;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         errorMessage = 'API Hatası: ${response.body}';
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'API isteğinde hata oluştu: $e';
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 400,
                              height: 450,
                              child: Image.file(
                                File(widget.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.blueGrey[50],
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Yüz Şekliniz: Oval",
                             // "Yüz Şekliniz: ${faceShapeResult ?? ''}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CameraPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'Fotoğraf Çek',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainNavigationBar(
                                              initialIndex: 1,
                                              faceShapeFilter: "Oval"
                                                  //faceShapeResult ?? ""
                                                  )));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'Gözlük Bul',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
