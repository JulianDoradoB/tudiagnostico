import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Título principal para la pantalla de ajustes
class AjustesTitle extends StatelessWidget {
  const AjustesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Configuración de la aplicación',
      style: GoogleFonts.openSans(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

/// Switch reutilizable para opciones como notificaciones o tema oscuro
class AjustesSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AjustesSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      activeColor: const Color(0xFF42A5F5),
      onChanged: onChanged,
    );
  }
}

/// Opción tipo card con ícono, título y acción (ej: cerrar sesión)
class AjustesOpcionCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final VoidCallback onTap;
  final Color colorIcono;

  const AjustesOpcionCard({
    super.key,
    required this.icon,
    required this.titulo,
    required this.onTap,
    this.colorIcono = const Color(0xFF1565C0),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: colorIcono),
        title: Text(
          titulo,
          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
