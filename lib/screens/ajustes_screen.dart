import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudiagnostico/controller/ajustes_controller.dart';
import 'package:tudiagnostico/widgets/ajustes_widgets.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

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
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: _AjustesContenido(),
        ),
      ),
    );
  }
}

class _AjustesContenido extends StatelessWidget {
  const _AjustesContenido({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AjustesController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AjustesTitle(),
            const SizedBox(height: 20),
            AjustesSwitchTile(
              title: 'Notificaciones',
              subtitle: 'Activar o desactivar notificaciones',
              value: controller.notificacionesActivas,
              onChanged: controller.toggleNotificaciones,
            ),
            AjustesSwitchTile(
              title: 'Tema oscuro',
              subtitle: 'Cambiar entre modo claro y oscuro',
              value: controller.temaOscuro,
              onChanged: controller.toggleTemaOscuro,
            ),
            const Divider(height: 32),
            AjustesOpcionCard(
              icon: Icons.logout,
              titulo: 'Cerrar sesión',
              colorIcono: Colors.red,
              onTap: () => controller.cerrarSesion(context),
            ),
          ],
        );
      },
    );
  }
}
