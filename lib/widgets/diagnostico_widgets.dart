import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiagnosticoIdFechaText extends StatelessWidget {
  final String id;
  final DateTime fecha;

  const DiagnosticoIdFechaText({Key? key, required this.id, required this.fecha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String fechaFormateada = 
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ID de análisis: $id', style: GoogleFonts.openSans(fontSize: 14)),
        Text('Fecha del diagnóstico: $fechaFormateada', style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

class DiagnosticoImagen extends StatelessWidget {
  final File imagen;

  const DiagnosticoImagen({Key? key, required this.imagen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(imagen, height: 200, width: double.infinity, fit: BoxFit.cover),
      ),
    );
  }
}

class DiagnosticoResultadoTitle extends StatelessWidget {
  const DiagnosticoResultadoTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Resultado del diagnóstico',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
      ),
    );
  }
}

class DiagnosticoResultadoWarning extends StatelessWidget {
  const DiagnosticoResultadoWarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Este resultado es generado automáticamente y debe ser evaluado por un profesional médico.',
      style: GoogleFonts.openSans(fontSize: 15, color: Colors.grey[800]),
    );
  }
}

class DiagnosticoResultadoBox extends StatelessWidget {
  final String resultado;

  const DiagnosticoResultadoBox({Key? key, required this.resultado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Text(resultado, style: GoogleFonts.openSans(fontSize: 17)),
      ),
    );
  }
}

class DiagnosticoButtonBuscarGoogle extends StatelessWidget {
  final VoidCallback onPressed;

  const DiagnosticoButtonBuscarGoogle({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.search, size: 28),
      label: const Text('Buscar en Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        textStyle: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class DiagnosticoButtonGuardarHistorial extends StatelessWidget {
  final bool isSaving;
  final bool alreadySaved;
  final VoidCallback? onPressed;

  const DiagnosticoButtonGuardarHistorial({
    Key? key,
    required this.isSaving,
    required this.alreadySaved,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: (isSaving || alreadySaved) ? null : onPressed,
      icon: isSaving
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            )
          : const Icon(Icons.save, size: 28),
      label: Text(alreadySaved ? 'Ya guardado' : 'Guardar en historial'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF43A047),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        textStyle: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class DiagnosticoNavigationButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHome;

  const DiagnosticoNavigationButtons({
    Key? key,
    required this.onBack,
    required this.onHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back, size: 24),
          label: const Text('Volver'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(150, 56),
            textStyle: GoogleFonts.openSans(fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onHome,
          icon: const Icon(Icons.home, size: 24),
          label: const Text('Inicio'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            minimumSize: const Size(150, 56),
            textStyle: GoogleFonts.openSans(fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
