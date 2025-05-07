import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF), // Fondo suave para dar un aire profesional
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animación para hacer que el logo aparezca de manera elegante
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 1), // Tiempo de animación
                  child: Image.asset(
                    'assets/images/logo.png', // Asegúrate de que esta ruta sea correcta
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40),
                // Título con mayor énfasis
                Text(
                  "Diagnóstico Dérmico Inteligente",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D47A1), // Azul sofisticado
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                // Descripción más amigable y clara
                Text(
                  "Obtén un análisis preliminar de lunares y afecciones cutáneas mediante inteligencia artificial. "
                  "Esta herramienta no reemplaza la evaluación médica profesional, por lo que siempre se recomienda consultar a un especialista.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 60),
                // Botón con animación y transiciones elegantes
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF42A5F5), // Color atractivo y profesional
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bordes redondeados para suavidad
                      ),
                      elevation: 6,
                      shadowColor: Colors.blueAccent.withOpacity(0.4), // Sombra sutil
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/nextScreen');
                    },
                    child: Text(
                      "Iniciar Diagnóstico",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
