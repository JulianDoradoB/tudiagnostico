import 'dart:io';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:tudiagnostico/service/replciate_service.dart';

class DiagnosticoResultado {
  final String id;
  final String resultado;
  final File imagen;
  final DateTime fecha;  // DateTime aquí

  DiagnosticoResultado({
    required this.id,
    required this.resultado,
    required this.imagen,
    required this.fecha,
  });
}

class DiagnosticoController {
  final ReplicateService _replicateService = ReplicateService();

  Future<DiagnosticoResultado> procesarDiagnostico(File imagen) async {
    final String resultado = await _replicateService.diagnosticarImagenFastAPI(imagen);
    final String id = const Uuid().v4();
    final DateTime fecha = DateTime.now();  // DateTime sin formatear

    return DiagnosticoResultado(
      id: id,
      resultado: resultado,
      imagen: imagen,
      fecha: fecha,  // Pasas DateTime directamente
    );
  }
}
