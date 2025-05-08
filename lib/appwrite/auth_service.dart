import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import '../appwrite/constants.dart';

class AuthService {
  Client client = Client()
      .setEndpoint(AppwriteConstants.endpoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true);

  late final Account account;

  AuthService() {
    account = Account(client);
  }

  Future<model.User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email.trim(),
        password: password.trim(),
        name: name.trim(),
      );
      return user;
    } on AppwriteException catch (e) {
      print('Error al registrar usuario: ${e.message}');
      return null;
    }
  }

  Future<model.Session?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Cambio de createEmailSession a createEmailPasswordSession
      final session = await account.createEmailPasswordSession(
        email: email.trim(),
        password: password.trim(),
      );
      return session;
    } on AppwriteException catch (e) {
      print('Error al iniciar sesión: ${e.message}');
      return null;
    }
  }

  Future<model.User?> getCurrentUser() async {
    try {
      return await account.get();
    } on AppwriteException catch (e) {
      print('Error al obtener usuario actual: ${e.message}');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      print('Error al cerrar sesión: ${e.message}');
    }
  }
}
