import 'package:flutter/material.dart';
import 'package:tudiagnostico/screens/home_screens';
import 'package:tudiagnostico/screens/login_screen.dart';
import 'package:tudiagnostico/screens/principal_screens.dart'; // Asegúrate del nombre correcto


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner DEBUG
      title: 'TuDiagnóstico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true, // Habilita Material 3 para un diseño más moderno
        fontFamily: 'Roboto', // Puedes personalizar aquí la fuente si deseas
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/nextScreen': (context) => PrincipalScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}