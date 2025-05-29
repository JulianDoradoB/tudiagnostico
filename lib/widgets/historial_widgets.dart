import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistorialCard extends StatelessWidget {
  final String resultado;
  final DateTime fecha;
  final String? imagenId;
  final Future<Uint8List?> Function(String imageId) obtenerImagen;
  final VoidCallback onEliminar;

  const HistorialCard({
    Key? key,
    required this.resultado,
    required this.fecha,
    required this.imagenId,
    required this.obtenerImagen,
    required this.onEliminar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(fecha);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(onEliminar: onEliminar),
            const SizedBox(height: 8),
            if (imagenId != null)
              FutureBuilder<Uint8List?>(
                future: obtenerImagen(imagenId!),
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
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onEliminar;

  const _Header({Key? key, required this.onEliminar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Diagnóstico',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Eliminar diagnóstico',
          onPressed: onEliminar,
        ),
      ],
    );
  }
}
