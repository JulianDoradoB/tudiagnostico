import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:tudiagnostico/controller/camera_controller.dart';
import 'package:tudiagnostico/service/replciate_service.dart';
import 'package:tudiagnostico/screens/diagnostico_screen.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tudiagnostico/appwrite/auth_service.dart';
import 'package:appwrite/models.dart' as model;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraControllerService _cameraService;
  late ReplicateService _replicateService;
  final ImagePicker _picker = ImagePicker();
  Client client = Client();
  late Storage storage;
  late Databases databases;
  final AuthService _authService = AuthService();
  String? _currentUserId;
  final String _databaseId = '681bd420001f5ae3cd26';
  final String _historialCollectionId = '682bb3a2001ec8d2ec88';
  final String _imagenesBucketId = '682bdab7002f4841f7f3';

  @override
  void initState() {
    super.initState();
    _cameraService = CameraControllerService();
    _replicateService = ReplicateService();
    _initializeAppwrite();
    _getCurrentUserId();
    _initializeCamera();
  }

  void _initializeAppwrite() {
    client
        .setEndpoint('https://fra.cloud.appwrite.io/v1')
        .setProject('681bd1fb0002d39bc1ed');
    storage = Storage(client);
    databases = Databases(client);
  }

  Future<void> _getCurrentUserId() async {
    model.User? user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUserId = user?.$id;
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('Error al inicializar la cámara: $e');
    }
  }

  Future<void> _takePictureAndDiagnose() async {
    if (!_cameraService.isCameraInitialized) {
      _showError('La cámara no está inicializada.');
      return;
    }

    try {
      final XFile xfile = await _cameraService.takePicture();
      final File imageFile = File(xfile.path);
      await _procesarDiagnostico(imageFile);
    } catch (e) {
      _showError('Error al tomar la foto: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File imageFile = File(image.path);
        await _procesarDiagnostico(imageFile);
      }
    } catch (e) {
      _showError('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _procesarDiagnostico(File imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final String fullResult = await _replicateService.diagnosticarImagenFastAPI(imageFile);
      String? diagnosis;
      String? description;

      // Intenta extraer diagnóstico y descripción si el formato es esperado
      if (fullResult.contains('Diagnóstico: ') && fullResult.contains('\nDescripción: ')) {
        final parts = fullResult.split('\nDescripción: ');
        diagnosis = parts[0].substring('Diagnóstico: '.length).trim();
        description = parts[1].trim();
      } else {
        // Si el formato no coincide, guarda el resultado completo
        diagnosis = fullResult;
      }

      final InputFile inputFile = InputFile.fromPath(path: imageFile.path, filename: 'diagnostico_${const Uuid().v4()}.jpg');
      final fileUploadResponse = await storage.createFile(
        bucketId: _imagenesBucketId,
        fileId: ID.unique(),
        file: inputFile,
      );

      final String fileId = fileUploadResponse.$id;
      final String id = const Uuid().v4();
      final DateTime fecha = DateTime.now();

      await databases.createDocument(
        databaseId: _databaseId,
        collectionId: _historialCollectionId,
        documentId: id,
        data: {
          'resultado': diagnosis, // Guardar solo el diagnóstico principal
          'descripcion': description, // Guardar la descripción por separado
          'imagen_id': fileId,
          'fecha_diagnostico': fecha.toIso8601String(),
          'userid': _currentUserId,
        },
      );

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosticoScreen(
            id: id,
            resultado: fullResult, // Pasar el resultado completo a la pantalla de diagnóstico
            imagen: imageFile,
            fecha: fecha,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      _showError('Error al procesar la imagen: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Text(
                  'Diagnóstico de Piel',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Asegúrate de tomar la foto con buena iluminación y enfocada. También puedes subir una imagen desde tu galería.',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              _cameraService.isCameraInitialized
                  ? Column(
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: CameraPreview(_cameraService.controller),
                            ),
                          ),
                        ),
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
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}