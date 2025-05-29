// camera_widgets.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraHeader extends StatelessWidget implements PreferredSizeWidget {
  const CameraHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Diagnóstico con cámara"),
      backgroundColor: const Color(0xFF42A5F5),
      centerTitle: true,
    );
  }
}

class CameraInfoMessage extends StatelessWidget {
  const CameraInfoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Toma una foto clara del área a analizar o selecciona una imagen de tu galería.",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}

class CameraPreviewBox extends StatelessWidget {
  final CameraController controller;

  const CameraPreviewBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }
}
