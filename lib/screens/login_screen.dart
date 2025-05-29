import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../appwrite/auth_service.dart';
import '../widgets/login_widgets.dart'; // 👈 Importación de widgets extraídos

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final session = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (session != null) {
        Navigator.pushReplacementNamed(context, '/nextScreen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al iniciar sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginLogo(),
                const SizedBox(height: 40),
                EmailField(controller: _emailController),
                const SizedBox(height: 20),
                PasswordField(controller: _passwordController),
                const SizedBox(height: 30),
                LoginButton(
                  isLoading: _isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),
                const RegisterRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
