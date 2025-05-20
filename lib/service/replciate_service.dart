import 'dart:io';
import 'package:dio/dio.dart';

class ReplicateService {
  final Dio _dio = Dio();
  
  // Usa 10.0.2.2 si estás en emulador Android, o la IP local de tu PC si usas un dispositivo físico
  final String _fastApiBaseUrl = 'http://10.0.2.2:8000';

  ReplicateService(); // Constructor por defecto

  Future<String> diagnosticarImagenFastAPI(File imageFile) async {
    try {
      // Leer los bytes de la imagen
      final bytes = await imageFile.readAsBytes();

      // Preparar el formulario para enviar la imagen
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: 'skin.jpg'),
      });

      // Enviar la imagen al endpoint de FastAPI
      final response = await _dio.post(
        '$_fastApiBaseUrl/predict',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Procesar la respuesta
      if (response.statusCode == 200 && response.data != null) {
        final diagnosis = response.data['diagnosis'];
        final description = response.data['description'];
        return 'Diagnóstico: $diagnosis\nDescripción: $description';
      } else {
        return 'Error al obtener el diagnóstico: ${response.statusMessage}';
      }
    } catch (e) {
      return 'Error durante la comunicación con la API: $e';
    }
  }
}
