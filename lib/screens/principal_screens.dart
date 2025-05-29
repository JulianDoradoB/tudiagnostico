import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'camera_screen.dart';
import 'historial_screen.dart';
import 'package:tudiagnostico/widgets/principal_widgets.dart'; // 👈 Importación del widget extraído

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Iniciar Sesión",
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.login, color: Colors.white, size: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "Bienvenido, Usuario 👋",
                style: GoogleFonts.raleway(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                "Selecciona una opción para continuar",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 50),

            PremiumOptionCard(
              icon: Icons.camera_alt_outlined,
              title: "Tomar Foto",
              subtitle: "Realiza un nuevo análisis dérmico",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen()));
              },
            ),
            const SizedBox(height: 20),

            PremiumOptionCard(
              icon: Icons.history,
              title: "Historial",
              subtitle: "Mira tus diagnósticos anteriores",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HistorialScreen()));
              },
            ),
            const SizedBox(height: 20),

            PremiumOptionCard(
              icon: Icons.settings,
              title: "Ajustes",
              subtitle: "Configura tu experiencia en la app",
              onTap: () {
                Navigator.pushNamed(context, '/ajustes');
              },
            ),
          ],
        ),
      ),
    );
  }
}
