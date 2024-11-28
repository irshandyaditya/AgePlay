import 'dart:io';
import 'dart:math' as math;
import 'package:age_play/widgets/displaypicture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import untuk galeri
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:image/image.dart' as img;

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
  //for focus
  Offset? _focusPoint;
  //For Zoom
  double _currentZoom = 1.0;
  File? _capturedImage;

  //for making sound
  // AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((value){
      if (!mounted) {
          return;
      }
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  void _toggleFlashLight() {
    if(_isFlashOn) {
      controller.setFlashMode(FlashMode.off);
      setState(() {
        _isFlashOn = false;
      });
    }
    else{
      controller.setFlashMode(FlashMode.torch);
      setState(() {
        _isFlashOn = true;
      });
    }
  }

  void _switchCamera() async {
    if (controller != null) {
      // Dispose the current controller to release the camera resource
      await controller.dispose();
    }

    // Increment or reset the selected camera index
    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;

    // Initialize the new camera
    _initCamera(_selectedCameraIndex);
  }

  Future<void> _initCamera(int cameraIndex) async {
    controller = CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);

    try {
      await controller.initialize();
      setState(() {
        if (cameraIndex == 0) {
          _isFrontCamera = false;
        }
        else{
          _isFrontCamera = true;
        }
      });
    } catch (e) {
      print("Error message: ${e}");
    }

    if(mounted){
      setState(() {
        
      });
    }
  }

  void capturePhoto() async {
    if (!controller.value.isInitialized) {
      return;
    }

    final Directory appDir = await pathProvider.getApplicationSupportDirectory();
    final String capturePath = path.join(appDir.path, '${DateTime.now()}.jpg');
    
    if (controller.value.isTakingPicture) {
      return;
    }

    try {
      setState(() {
        isCapturing = true;
      });

      // Ambil gambar dari kamera
      final image = await controller.takePicture();

      if (_isFrontCamera) {
        // Jika kamera depan, proses gambar untuk menghilangkan efek mirror
        final originalImage = File(image.path);
        final bytes = await originalImage.readAsBytes();

        // Proses menggunakan package `image`
        final decodedImage = img.decodeImage(bytes);
        final flippedImage = img.flipHorizontal(decodedImage!); // Membalik gambar horizontal
        final flippedImageBytes = img.encodeJpg(flippedImage);

        // Simpan gambar yang sudah diproses
        final flippedFile = File(capturePath);
        await flippedFile.writeAsBytes(flippedImageBytes);

        // Navigasikan ke layar berikutnya dengan gambar yang sudah tidak mirror
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: flippedFile.path,
            ),
          ),
        );
      } else {
        // Navigasi langsung untuk kamera belakang (tidak perlu transformasi)
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: image.path,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error capturing photo: $e");
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){
            return Stack(
              children: [
                Center(child: CircularProgressIndicator()), // Tampilkan loading jika belum siap
    
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_sharp, color: Colors.white)
                          ),
                        ),
                        if (_isFrontCamera == false)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                _toggleFlashLight();
                              },
                              child: _isFlashOn == false ? Icon(Icons.flash_off, color: Colors.white) : Icon(Icons.flash_on, color: Colors.white),
                            ),
                          ),
                        
                      ],
                    ),
                  )
                ),
                if (controller.value.isInitialized)
                  Positioned.fill(
                    top: 50,
                    bottom: _isFrontCamera == false ? 0 : 150,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: _isFrontCamera
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi), // Membalik horizontal (mirror)
                              child: CameraPreview(controller),
                            )
                          : CameraPreview(controller), // Kamera belakang tidak perlu transform
                    ),
                  )
                else
                  Center(child: CircularProgressIndicator()), // Loading jika belum siap
                // camera
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0, // Tambahkan right untuk memenuhi lebar
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: _isFrontCamera == false ? Colors.black45 : Colors.black,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text("Video",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text("Photo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text("Pro Mode",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Container()),

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
                                              style: BorderStyle.solid
                                            )
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
                                      child: Icon(Icons.cameraswitch_sharp, color: Colors.white, size: 50), // Ukuran ikon diatur ulang
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
