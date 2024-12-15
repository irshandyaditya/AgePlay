import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'package:age_play/pages/displaypicture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  TakePictureScreen(this.cameras);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController controller;
  bool isCapturing = false;
  //for switch camera
  int _selectedCameraIndex = 0;
  bool _isFrontCamera = false;
  //for flash
  bool _isFlashOn = false;
  bool isLoading = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleFlashLight() {
    if (_isFlashOn) {
      controller.setFlashMode(FlashMode.off);
      setState(() {
        _isFlashOn = false;
      });
    } else {
      controller.setFlashMode(FlashMode.torch);
      setState(() {
        _isFlashOn = true;
      });
    }
  }

  void _switchCamera() async {
    if (controller != null) {
      await controller.dispose();
    }

    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    _initCamera(_selectedCameraIndex);
  }

  Future<void> _initCamera(int cameraIndex) async {
    controller = CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);
    try {
      await controller.initialize();
      setState(() {
        if (cameraIndex == 0) {
          _isFrontCamera = false;
        } else {
          _isFrontCamera = true;
        }
      });
    } catch (e) {
      print("Error message: \${e}");
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadPhoto(_image!);
    }
  }

  void capturePhoto() async {
    if (!controller.value.isInitialized) {
      return;
    }

    final Directory appDir = await pathProvider.getApplicationSupportDirectory();
    final String capturePath = path.join(appDir.path, '\${DateTime.now()}.jpg');

    if (controller.value.isTakingPicture) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final image = await controller.takePicture();

      await Future.delayed(Duration(seconds: 2)); 

      File finalImage;

      if (_isFrontCamera) {
        final originalImage = File(image.path);
        final bytes = await originalImage.readAsBytes();
        final decodedImage = img.decodeImage(bytes);
        final flippedImage = img.flipHorizontal(decodedImage!);
        final flippedImageBytes = img.encodeJpg(flippedImage);

        final flippedFile = File(capturePath);
        await flippedFile.writeAsBytes(flippedImageBytes);
        finalImage = flippedFile;
      } else {
        finalImage = File(image.path);
      }

      _uploadPhoto(finalImage);
    } catch (e) {
      print("Error capturing photo: \$e");
    }
  }

  Future<void> _uploadPhoto(File imageFile) async {
    const String apiUrl = 'https://polinemaesports.my.id/api/predict/';
    try {
      setState(() {
        isLoading = true;
      });
      
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      Map<String, dynamic>? jsonResponse;

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        jsonResponse = json.decode(responseBody);
        print("Upload sukses: \$jsonResponse");
      } else {
        print("Upload gagal: \${response.statusCode}");
      }

      final age = jsonResponse?['age'] ?? 'Unknown';
      final gender = jsonResponse?['gender'] ?? 'Unknown';

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: imageFile.path,
            age: age,
            gender: gender,
          ),
        ),
      );
    } catch (e) {
      print("Error capturing photo: \$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Center(child: CircularProgressIndicator(color: Colors.red,)), // Tampilkan loading jika belum siap
                if (controller.value.isInitialized)
                  Positioned.fill(
                    top: 0,
                    bottom: _isFrontCamera == false ? 0 : 0,
                    left: -100,
                    right: -100,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: _isFrontCamera
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: CameraPreview(controller),
                            )
                          : CameraPreview(controller),
                    ),
                  )
                else
                  Center(child: CircularProgressIndicator(color: Colors.red,)),

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
                          ),
                        ),
                        if (_isFrontCamera == false)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                _toggleFlashLight();
                              },
                              child: _isFlashOn == false
                                  ? Icon(Icons.flash_off, color: Colors.white)
                                  : Icon(Icons.flash_on, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // color: _isFrontCamera == false ? Colors.black45 : Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImage(false);
                                      },
                                      child: Icon(Icons.image_outlined, color: Colors.white, size: 50),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        capturePhoto();
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(
                                              width: 4,
                                              color: Colors.white,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _switchCamera();
                                      },
                                      child: Icon(Icons.cameraswitch_sharp, color: Colors.white, size: 50),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Menambahkan indikator loading tambahan
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(1), // Latar putih transparan
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Animasi loading menggunakan circleStrokeSpin
                                SizedBox(
                                  width: 120, // Ukuran lingkaran animasi
                                  height: 120,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.circleStrokeSpin,
                                    colors: [const Color.fromARGB(255, 245, 245, 245)],
                                    strokeWidth: 3.0,
                                    // pathBackgroundColor: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 200, // Ukuran lingkaran animasi
                                  height: 200,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballScaleRippleMultiple,
                                    colors: [const Color.fromARGB(255, 233, 233, 233)],
                                    strokeWidth: 4.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 280, // Ukuran lingkaran animasi
                                  height: 280,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballScaleRippleMultiple,
                                    colors: [const Color.fromARGB(255, 247, 247, 247), const Color.fromARGB(255, 255, 216, 216), const Color.fromARGB(255, 216, 238, 255)],
                                    strokeWidth: 4.0,
                                  ),
                                ),
                                // Ikon profil di tengah
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color.fromARGB(255, 28, 94, 199).withOpacity(0.8),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Processing...",
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
