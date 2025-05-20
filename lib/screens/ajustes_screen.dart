import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tudiagnostico/controller/ajustes_controller.dart'; // Asegúrate que la ruta sea correcta

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AjustesController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FA),
        appBar: AppBar(
          title: const Text('Ajustes'),
          backgroundColor: const Color(0xFF1565C0),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<AjustesController>(
            builder: (context, controller, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuración de la aplicación',
                    style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text('Notificaciones'),
                    subtitle: const Text('Activar o desactivar notificaciones'),
                    value: controller.notificacionesActivas,
                    activeColor: const Color(0xFF42A5F5),
                    onChanged: controller.toggleNotificaciones,
                  ),

                  SwitchListTile(
                    title: const Text('Tema oscuro'),
                    subtitle: const Text('Cambiar entre modo claro y oscuro'),
                    value: controller.temaOscuro,
                    activeColor: const Color(0xFF42A5F5),
                    onChanged: controller.toggleTemaOscuro,
                  ),

                  const Divider(height: 32),

                  _buildOpcion(
                    context,
                    icon: Icons.logout,
                    titulo: 'Cerrar sesión',
                    colorIcono: Colors.red,
                    onTap: () => controller.cerrarSesion(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOpcion(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required VoidCallback onTap,
    Color colorIcono = const Color(0xFF1565C0),
  }) {
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
