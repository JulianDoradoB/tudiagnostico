import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:tudiagnostico/appwrite/auth_service.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({Key? key}) : super(key: key);

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late final Client client;
  late final Databases databases;
  late final Storage storage;
  final AuthService _authService = AuthService();

  final String _databaseId = '681bd420001f5ae3cd26';
  final String _collectionId = '682bb3a2001ec8d2ec88';
  final String _bucketId = '682bdab7002f4841f7f3';

  List<models.Document> historiales = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    client = Client()
      ..setEndpoint('https://fra.cloud.appwrite.io/v1')
      ..setProject('681bd1fb0002d39bc1ed');
    databases = Databases(client);
    storage = Storage(client);
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('Usuario no autenticado');

      final response = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [Query.equal('userid', user.$id)],
      );

      setState(() {
        historiales = response.documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el historial: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _eliminarHistorial(String docId) async {
    try {
      await databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: docId,
      );
      _cargarHistorial(); // Recargar después de eliminar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar diagnóstico: $e')),
      );
    }
  }

  Future<void> _confirmarEliminacion(String docId) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar diagnóstico?'),
        content: const Text('Esta acción no se puede deshacer. ¿Seguro que deseas eliminar este diagnóstico?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context, false)),
          TextButton(child: const Text('Eliminar', style: TextStyle(color: Colors.red)), onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (confirmado == true) {
      _eliminarHistorial(docId);
    }
  }

  Future<Uint8List?> _getImageBytes(String imageId) async {
    try {
      final data = await storage.getFileDownload(
        bucketId: _bucketId,
        fileId: imageId,
      );
      return data; // Ya es Uint8List en Appwrite 15.0.0
    } catch (e) {
      print('Error al obtener imagen: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Diagnósticos'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : historiales.isEmpty
                  ? const Center(child: Text('No hay diagnósticos en tu historial.'))
                  : ListView.builder(
                      itemCount: historiales.length,
                      itemBuilder: (context, index) {
                        final doc = historiales[index];
                        final data = doc.data;

                        final String resultado = data['resultado'] ?? 'Sin resultado';
                        final String? imagenId = data['imagen_id'];
                        final DateTime fecha = DateTime.tryParse(data['fecha_diagnostico'] ?? '') ?? DateTime.now();
                        final String fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(fecha);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Diagnóstico',
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Eliminar diagnóstico',
                                      onPressed: () => _confirmarEliminacion(doc.$id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (imagenId != null)
                                  FutureBuilder<Uint8List?>(
                                    future: _getImageBytes(imagenId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const SizedBox(
                                          height: 150,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      } else if (snapshot.hasError || snapshot.data == null) {
                                        return const Text('No se pudo cargar la imagen');
                                      } else {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.memory(
                                            snapshot.data!,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  resultado,
                                  style: GoogleFonts.openSans(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Fecha: $fechaFormateada',
                                  style: GoogleFonts.openSans(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
