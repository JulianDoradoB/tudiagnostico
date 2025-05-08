import 'package:flutter/material.dart';
import 'package:tudiagnostico/screens/home_screens.dart';
import 'package:tudiagnostico/screens/login_screen.dart';
import 'package:tudiagnostico/screens/principal_screens.dart'; 
import 'package:tudiagnostico/screens/register_screen.dart';
import 'package:tudiagnostico/screens/camera_screen.dart'; // Asegúrate de importar la pantalla de la cámara

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TuDiagnóstico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/nextScreen': (context) => PrincipalScreen(), // Pantalla principal
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/camera': (context) => CameraScreen(),  // Ruta para la cámara
      },
    );
  }
}
