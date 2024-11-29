import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:age_play/widgets/bottom_navbar.dart';
import 'package:age_play/widgets/takepicture_screen.dart';

class Camera extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<Camera> {
  CameraDescription? selectedCamera;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Mendapatkan daftar kamera yang tersedia
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

    // Jika ada kamera yang tersedia, pilih yang pertama
    if (cameras.isNotEmpty) {
      setState(() {
        selectedCamera = cameras.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: cameras.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TakePictureScreen(cameras), // Panggil `TakePictureScreen` dengan kamera yang dipilih
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}