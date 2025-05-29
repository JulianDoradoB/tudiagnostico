import 'package:flutter/material.dart';
import 'package:tudiagnostico/widgets/home_screen.dart'; // Importas todos desde aquí

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                HomeLogo(),
                SizedBox(height: 40),
                HomeTitle(),
                SizedBox(height: 20),
                HomeDescription(),
                SizedBox(height: 60),
                HomeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
