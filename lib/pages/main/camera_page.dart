import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

import 'package:visio_fit/pages/main/result_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  bool isRearCamera = true;
  double zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraPreview(),

          // Dikey Zoom Slider (sağ kenarda)
          /* Positioned(
            top: 100,
            bottom: 100,
            right: 10,
            child: RotatedBox(
              quarterTurns: 3, // Yataydan dikeye çevirir
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: zoomLevel,
                      min: 1.0,
                      max: 8.0,
                      divisions: 14,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onChanged: (value) async {
                        setState(() => zoomLevel = value);
                        await cameraController?.setZoomLevel(zoomLevel);
                      },
                    ),
                  ),
                  Text("${zoomLevel.toStringAsFixed(1)}x",
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ), */

          // Alt Siyah Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    iconSize: 40,
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultPage(imagePath: image.path),
                          ),
                        );
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picture = await cameraController!.takePicture();
                      Gal.putImage(picture.path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultPage(imagePath: picture.path),
                        ),
                      );
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.flip_camera_ios, color: Colors.white),
                    iconSize: 40,
                    onPressed: _toggleCamera,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
  if (cameraController == null || !cameraController!.value.isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }

  return SafeArea(
    child: Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(isRearCamera ? 1.0 : -1.0, 1.0),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: cameraController!.value.previewSize!.height,
          height: cameraController!.value.previewSize!.width,
          child: CameraPreview(cameraController!),
        ),
      ),
    ),
  );
}


  Widget _blurBar({required double height, required Widget child}) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.black.withOpacity(0.3),
          child: child,
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    cameras = await availableCameras();

    final selectedCamera = isRearCamera
        ? cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.back,
            orElse: () => cameras.first,
          )
        : cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

    cameraController?.dispose();
    cameraController = CameraController(selectedCamera, ResolutionPreset.high);
    await cameraController?.initialize();
    await cameraController?.setZoomLevel(zoomLevel);
    setState(() {});
  }

  Future<void> _toggleCamera() async {
    // Önce controller'ı null yap ve preview'i boşalt
    setState(() {
      cameraController?.dispose();
      cameraController = null;
    });

    // Kamerayı değiştir
    setState(() => isRearCamera = !isRearCamera);

    // Yeni controller'ı kur
    await _setupCameraController();
  }
}
