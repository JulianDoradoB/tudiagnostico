import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrincipalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
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
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                const Spacer(), // Eliminar TUDIAGNÓSTICO
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla de Login al presionar el botón
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // El ícono y el texto estarán juntos
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
                      Icon(
                        Icons.login, // Ícono que resalta el botón
                        color: Colors.white,
                        size: 18,
                      ),
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
            // Mensaje de bienvenida con un pequeño ajuste hacia la izquierda
            Padding(
              padding: const EdgeInsets.only(right: 10), // Ajustar el padding aquí
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
              padding: const EdgeInsets.only(right: 12), // Ajustar el padding aquí
              child: Text(
                "Selecciona una opción para continuar",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Botones principales
            _PremiumOptionCard(
              icon: Icons.camera_alt_outlined,
              title: "Tomar Foto",
              subtitle: "Realiza un nuevo análisis dérmico",
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _PremiumOptionCard(
              icon: Icons.history,
              title: "Historial",
              subtitle: "Consulta tus análisis anteriores",
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _PremiumOptionCard(
              icon: Icons.settings,
              title: "Ajustes",
              subtitle: "Configura tu experiencia en la app",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta elegante para opciones del menú
class _PremiumOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PremiumOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Color(0xFF90CAF9).withOpacity(0.3),
        child: Padding( // Usamos Padding directamente en el InkWell en lugar de un Container con altura fija
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, size: 30, color: Color(0xFF1976D2)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Añadido para asegurar que la columna no ocupe espacio vertical innecesario
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}