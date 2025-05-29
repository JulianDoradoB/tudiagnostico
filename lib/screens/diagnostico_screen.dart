import 'dart:io';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tudiagnostico/appwrite/auth_service.dart';
import 'package:tudiagnostico/screens/principal_screens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tudiagnostico/service/diagnostocos_service.dart'; // <-- Nuevo servicio
import 'package:tudiagnostico/widgets/diagnostico_widgets.dart'; // <-- Widgets UI

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
  late final DiagnosticoService _diagnosticoService;

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

    _diagnosticoService = DiagnosticoService(
      client: client,
      authService: _authService,
      databaseId: _databaseId,
      collectionId: _collectionId,
      bucketId: _bucketId,
    );
  }

  void _abrirGoogle(String query) async {
    final url = Uri.parse("https://www.google.com/search?q=${Uri.encodeComponent(query)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el navegador.')),
        );
      }
    }
  }

  Future<void> guardarEnHistorial() async {
    if (_alreadySaved) return;

    setState(() => _isSaving = true);

    try {
      final saved = await _diagnosticoService.guardarDiagnostico(
        resultado: widget.resultado,
        imagen: widget.imagen,
        fecha: widget.fecha,
      );

      if (!saved) {
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

      setState(() => _alreadySaved = true);

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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            DiagnosticoIdFechaText(id: widget.id, fecha: widget.fecha),
            const SizedBox(height: 20),
            DiagnosticoImagen(imagen: widget.imagen),
            const SizedBox(height: 28),
            const DiagnosticoResultadoTitle(),
            const SizedBox(height: 12),
            const DiagnosticoResultadoWarning(),
            const SizedBox(height: 16),
            Expanded(child: DiagnosticoResultadoBox(resultado: widget.resultado)),
            const SizedBox(height: 16),
            DiagnosticoButtonBuscarGoogle(onPressed: () => _abrirGoogle(widget.resultado)),
            const SizedBox(height: 12),
            DiagnosticoButtonGuardarHistorial(
              isSaving: _isSaving,
              alreadySaved: _alreadySaved,
              onPressed: guardarEnHistorial,
            ),
            const SizedBox(height: 12),
            DiagnosticoNavigationButtons(
              onBack: () => Navigator.pop(context),
              onHome: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PrincipalScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
