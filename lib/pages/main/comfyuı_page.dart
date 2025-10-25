import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:visio_fit/config/app_config.dart';

class ComfyUI extends StatefulWidget {
  final String glassesImageUrl;

  const ComfyUI({super.key, required this.glassesImageUrl});

  @override
  State<ComfyUI> createState() => _ComfyUIState();
}

class _ComfyUIState extends State<ComfyUI> {
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Galeriden resim seçilirken hata oluştu: $e');
    }
  }

  Future<void> _uploadImage(File selfieFile, String glassesUrl) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final response = await http.get(Uri.parse(glassesUrl));
      final tempDir = await getTemporaryDirectory();
      final glassesFile = File('${tempDir.path}/glasses.png');
      await glassesFile.writeAsBytes(response.bodyBytes);

      final request = http.MultipartRequest(
          'POST', Uri.parse(AppConfig.uploadEndpoint));

      request.files.add(await http.MultipartFile.fromPath(
        "selfie",
        selfieFile.path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        "glasses",
        glassesFile.path,
      ));

      final resStream = await request.send();

      if (resStream.statusCode == 200) {
        print('Resim başarıyla yüklendi');
      } else {
        print('Resim yükleme hatası: ${resStream.statusCode}');
      }
    } catch (e) {
      print("Yükleme sırasında hata: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComfyUI'),
      ),
      body: Column(
        children: [
          Image.network(
            widget.glassesImageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Galeriden Resim Seç'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          if(_selectedImage != null)
            ElevatedButton.icon(
              onPressed: _isUploading ? null : () => _uploadImage(_selectedImage!, widget.glassesImageUrl),
              icon: const Icon(Icons.cloud_upload),
              label: _isUploading ? const Text('Yükleniyor...') : const Text('Resim Yükle'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }
}
