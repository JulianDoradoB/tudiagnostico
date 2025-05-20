// camera_controller.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraControllerService {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  CameraControllerService();

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw 'No hay cámaras disponibles';
      }

      _cameraController = CameraController(cameras.first, ResolutionPreset.medium);
      await _cameraController.initialize();
      _isCameraInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  CameraController get controller => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;

  Future<XFile> takePicture() async {
    if (!_isCameraInitialized) {
      throw 'La cámara no está inicializada';
    }
    return await _cameraController.takePicture();
  }

  void dispose() {
    _cameraController.dispose();
  }
}