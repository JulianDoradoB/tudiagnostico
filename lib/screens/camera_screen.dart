import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tudiagnostico/controller/camera_controller.dart';
import 'package:tudiagnostico/widgets/camera_widgets.dart'; // Todos los widgets aquí

import 'package:tudiagnostico/screens/diagnostico_screen.dart';  // <-- Importa tu pantalla de diagnóstico
import 'dart:io'; // para File

// Asumo que tienes este import para tu controlador DiagnosticoController
import 'package:tudiagnostico/controller/diagnostico_controller.dart';  

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraControllerService _cameraService = CameraControllerService();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = true;
  bool _isProcessing = false;  // Para estado de carga al procesar imagen

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
    } catch (e) {
      debugPrint('Error inicializando cámara: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePictureAndDiagnose() async {
    setState(() => _isProcessing = true);
    try {
      final picture = await _cameraService.takePicture();
      if (picture != null) {
        print('Foto tomada: ${picture.path}');

        final diagnosticoController = DiagnosticoController();
        final resultadoDiagnostico = await diagnosticoController.procesarDiagnostico(File(picture.path));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiagnosticoScreen(
              id: resultadoDiagnostico.id,
              resultado: resultadoDiagnostico.resultado,
              imagen: resultadoDiagnostico.imagen,
              fecha: resultadoDiagnostico.fecha,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error al tomar foto o procesar diagnóstico: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() => _isProcessing = true);
    try {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('Imagen seleccionada: ${pickedFile.path}');

        final diagnosticoController = DiagnosticoController();
        final resultadoDiagnostico = await diagnosticoController.procesarDiagnostico(File(pickedFile.path));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiagnosticoScreen(
              id: resultadoDiagnostico.id,
              resultado: resultadoDiagnostico.resultado,
              imagen: resultadoDiagnostico.imagen,
              fecha: resultadoDiagnostico.fecha,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen o procesar diagnóstico: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: const CameraHeader(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CameraInfoMessage(),
                    const SizedBox(height: 16),
                    if (_isProcessing)
                      const CircularProgressIndicator()
                    else if (_cameraService.isCameraInitialized)
                      Column(
                        children: [
                          CameraPreviewBox(controller: _cameraService.controller),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _takePictureAndDiagnose,
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: const Text("Analizar imagen con cámara"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF42A5F5),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Subir imagen desde galería"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              side: const BorderSide(color: Color(0xFF42A5F5)),
                            ),
                          ),
                        ],
                      )
                    else
                      const Text('No se pudo inicializar la cámara'),
                  ],
                ),
        ),
      ),
    );
  }
}
