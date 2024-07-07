import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();

    setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';

      // Ensure the controller is initialized before attempting to take a picture
      if (!_controller.value.isInitialized) {
        throw 'Error: Camera controller is not initialized';
      }

      // await _controller.takePicture(imagePath);

      setState(() {
        _imagePath = imagePath;
      });

      // You can now use _imagePath to display the captured image or process it further.
    } catch (e) {
      print('Error taking picture: $e');
      // Handle the error appropriately, e.g., show a snackbar or log the error
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraPreview(_controller),
          ),
          SizedBox(height: 20),
          _imagePath != null
              ? Image.file(File(_imagePath))
              : ElevatedButton(
                  onPressed: _takePicture,
                  child: Icon(Icons.camera),
                ),
        ],
      ),
    );
  }
}
