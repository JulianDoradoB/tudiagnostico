import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: Image.asset(
        'assets/images/logo.png',
        height: 160,
        fit: BoxFit.contain,
      ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Diagnóstico Dérmico Inteligente",
      textAlign: TextAlign.center,
      style: GoogleFonts.raleway(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0D47A1),
        letterSpacing: 1.2,
      ),
    );
  }
}

class HomeDescription extends StatelessWidget {
  const HomeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Obtén un análisis preliminar de lunares y afecciones cutáneas mediante inteligencia artificial. "
      "Esta herramienta no reemplaza la evaluación médica profesional, por lo que siempre se recomienda consultar a un especialista.",
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(
        fontSize: 18,
        color: Colors.grey[700],
        height: 1.6,
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF42A5F5),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: Colors.blueAccent.withOpacity(0.4),
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
    );
  }
}
