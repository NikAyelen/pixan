import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      builder: (context, w, h) => Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.1),
        child: Column(
          children: [
            Center(child: BrandHeader(w: w, h: h)),
            SizedBox(height: h * 0.1),
            AuthButton.light(
              'Iniciar sesión',
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
            const SizedBox(height: 28),
            AuthButton.white(
              'Crear cuenta',
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}