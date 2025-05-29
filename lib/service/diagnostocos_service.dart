import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:tudiagnostico/appwrite/auth_service.dart';

class DiagnosticoService {
  final Client client;
  final AuthService authService;

  final String databaseId;
  final String collectionId;
  final String bucketId;

  late final Databases databases;
  late final Storage storage;

  DiagnosticoService({
    required this.client,
    required this.authService,
    required this.databaseId,
    required this.collectionId,
    required this.bucketId,
  }) {
    databases = Databases(client);
    storage = Storage(client);
  }

  Future<bool> guardarDiagnostico({
    required String resultado,
    required File imagen,
    required DateTime fecha,
  }) async {
    final user = await authService.getCurrentUser();
    if (user == null) throw Exception('Usuario no autenticado');

    // Revisión de existencia
    final existing = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      queries: [
        Query.equal('userid', user.$id),
        Query.equal('resultado', resultado),
        Query.equal('fecha_diagnostico', fecha.toUtc().toIso8601String()),
      ],
    );

    if (existing.documents.isNotEmpty) {
      return false; // Ya existe
    }

    // Subir archivo
    final inputFile = InputFile.fromPath(path: imagen.path);
    final file = await storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: inputFile,
    );

    // Crear documento
    await databases.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        'userid': user.$id,
        'resultado': resultado,
        'imagen_id': file.$id,
        'fecha_diagnostico': fecha.toUtc().toIso8601String(),
      },
    );

    return true; // Guardado exitoso
  }
}
