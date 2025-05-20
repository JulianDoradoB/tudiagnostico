import 'package:flutter/material.dart';

class AjustesController extends ChangeNotifier {
  bool _notificacionesActivas = true;
  bool _temaOscuro = false;

  bool get notificacionesActivas => _notificacionesActivas;
  bool get temaOscuro => _temaOscuro;

  void toggleNotificaciones(bool value) {
    _notificacionesActivas = value;
    notifyListeners();
  }

  void toggleTemaOscuro(bool value) {
    _temaOscuro = value;
    notifyListeners();
  }

  void cerrarSesion(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
