import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:tudiagnostico/appwrite/auth_service.dart';

class HistorialService {
  final AuthService _authService = AuthService();
  final Client _client = Client()
    ..setEndpoint('https://fra.cloud.appwrite.io/v1')
    ..setProject('681bd1fb0002d39bc1ed');
  late final Databases _databases;
  late final Storage _storage;

  final String _databaseId = '681bd420001f5ae3cd26';
  final String _collectionId = '682bb3a2001ec8d2ec88';
  final String _bucketId = '682bdab7002f4841f7f3';

  HistorialService() {
    _databases = Databases(_client);
    _storage = Storage(_client);
  }

  Future<List<models.Document>> obtenerHistorial() async {
    final user = await _authService.getCurrentUser();
    if (user == null) throw Exception('Usuario no autenticado');

    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _collectionId,
      queries: [Query.equal('userid', user.$id)],
    );

    return response.documents;
  }

  Future<void> eliminarDiagnostico(String docId) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: docId,
    );
  }

  Future<Uint8List?> obtenerImagen(String fileId) async {
    try {
      return await _storage.getFileDownload(
        bucketId: _bucketId,
        fileId: fileId,
      );
    } catch (e) {
      print('Error al obtener imagen: $e');
      return null;
    }
  }
}
