import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appwrite/models.dart' as models;
import 'package:tudiagnostico/widgets/historial_widgets.dart';
import 'package:tudiagnostico/service/historial_service.dart'; // ⬅️ Nuevo import

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({Key? key}) : super(key: key);

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final HistorialService _historialService = HistorialService();

  List<models.Document> historiales = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final docs = await _historialService.obtenerHistorial();
      setState(() {
        historiales = docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el historial: $e';
        _isLoading = false;
      });
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
      try {
        await _historialService.eliminarDiagnostico(docId);
        _cargarHistorial();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar diagnóstico: $e')),
        );
      }
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

                        return HistorialCard(
                          resultado: resultado,
                          fecha: fecha,
                          imagenId: imagenId,
                          obtenerImagen: _historialService.obtenerImagen,
                          onEliminar: () => _confirmarEliminacion(doc.$id),
                        );
                      },
                    ),
    );
  }
}
