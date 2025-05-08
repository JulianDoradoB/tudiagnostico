import 'dart:io';
import 'package:dio/dio.dart';

class AlabService {
  final Dio _dio = Dio();
  final String _apiKey = 'MrUcn2twJpXYzqLeiKVssHw59k0ZPBAyQ9ay71kNG7XCRpmmEPxfCSGOEoQ0MvcW';
  final String _apiUrl = 'https://api.ailabtools.com/api/portrait/skin-disease-detect';

  Future<String> diagnosticarImagen(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: 'skin.jpg'),  // CAMBIO: 'file' es el nombre correcto
      });

      final response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final result = response.data;

        if (result['data'] != null) {
          return 'Resultado: ${result['data']}';
        } else if (result['msg'] != null) {
          return 'Mensaje de la API: ${result['msg']}';
        } else {
          return 'Respuesta sin diagnóstico claro.';
        }
      } else {
        return 'Error: ${response.statusMessage}';
      }
    } catch (e) {
      return 'Error durante el análisis: $e';
    }
  }
}
