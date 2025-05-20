import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:tudiagnostico/screens/principal_screens.dart';
import 'package:tudiagnostico/appwrite/auth_service.dart';

class DiagnosticoScreen extends StatefulWidget {
  final String id;
  final String resultado;
  final File imagen;
  final DateTime fecha;

  const DiagnosticoScreen({
    Key? key,
    required this.id,
    required this.resultado,
    required this.imagen,
    required this.fecha,
  }) : super(key: key);

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen> {
  late final Client client;
  late final Databases databases;
  late final Storage storage;
  final AuthService _authService = AuthService();

  final String _databaseId = '681bd420001f5ae3cd26';
  final String _collectionId = '682bb3a2001ec8d2ec88';
  final String _bucketId = '682bdab7002f4841f7f3';

  bool _isSaving = false;
  bool _alreadySaved = false;

  @override
  void initState() {
    super.initState();
    client = Client()
      ..setEndpoint('https://fra.cloud.appwrite.io/v1')
      ..setProject('681bd1fb0002d39bc1ed');
    databases = Databases(client);
    storage = Storage(client);
  }

  void _abrirGoogle(String query) async {
    final url = Uri.parse("https://www.google.com/search?q=${Uri.encodeComponent(query)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el navegador.')),
      );
    }
  }

  Future<void> guardarEnHistorial() async {
    if (_alreadySaved) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('Usuario no autenticado');

      // 🚫 VERIFICAR DUPLICADOS EN BASE DE DATOS
      final existing = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('userid', user.$id),
          Query.equal('resultado', widget.resultado),
          Query.equal('fecha_diagnostico', widget.fecha.toUtc().toIso8601String()),
        ],
      );

      if (existing.documents.isNotEmpty) {
        setState(() {
          _alreadySaved = true;
          _isSaving = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este diagnóstico ya está guardado.')),
          );
        }
        return;
      }

      final inputFile = InputFile.fromPath(path: widget.imagen.path);
      final file = await storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: inputFile,
      );

      await databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: ID.unique(),
        data: {
          'userid': user.$id,
          'resultado': widget.resultado,
          'imagen_id': file.$id,
          'fecha_diagnostico': widget.fecha.toUtc().toIso8601String(),
        },
      );

      setState(() {
        _alreadySaved = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnóstico guardado en el historial')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(widget.fecha);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        title: const Text('Diagnóstico'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID de análisis: ${widget.id}', style: GoogleFonts.openSans(fontSize: 14)),
            Text('Fecha del diagnóstico: $fechaFormateada', style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(widget.imagen, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 28),
            Text('Resultado del diagnóstico', style: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Este resultado es generado automáticamente y debe ser evaluado por un profesional médico.',
              style: GoogleFonts.openSans(fontSize: 15, color: Colors.grey[800]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: SingleChildScrollView(
                  child: Text(widget.resultado, style: GoogleFonts.openSans(fontSize: 17)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _abrirGoogle(widget.resultado),
              icon: const Icon(Icons.search, size: 28),
              label: const Text('Buscar en Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                textStyle: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isSaving || _alreadySaved ? null : guardarEnHistorial,
              icon: _isSaving
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : const Icon(Icons.save, size: 28),
              label: Text(_alreadySaved ? 'Ya guardado' : 'Guardar en historial'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                textStyle: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 24),
                  label: const Text('Volver'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(150, 56),
                    textStyle: GoogleFonts.openSans(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PrincipalScreen())),
                  icon: const Icon(Icons.home, size: 24),
                  label: const Text('Inicio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 56),
                    textStyle: GoogleFonts.openSans(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
