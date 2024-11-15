import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import untuk galeri
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){
            return Stack(
              children: [
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
                              _toggleFlashLight();
                            },
                            child: _isFlashOn == false ? Icon(Icons.flash_off, color: Colors.white) : Icon(Icons.flash_on, color: Colors.white),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Icon(Icons.qr_code_scanner, color: Colors.white)
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                Positioned.fill(
                  top: 50,
                  bottom: _isFrontCamera == false ? 0 : 150,
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
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
