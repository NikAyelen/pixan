import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/session.dart';
import 'auth_widgets.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _aviso(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> iniciarSesion() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();

    final correo = emailController.text.trim();
    // La contraseña NO se recorta: se guardó tal cual al registrarse.
    final contrasena = passwordController.text;

    if (correo.isEmpty || contrasena.isEmpty) {
      _aviso('Ingresa tu correo y contraseña');
      return;
    }

    setState(() => _loading = true);

    try {
      final user = await AuthApi.login(correo: correo, password: contrasena);
      if (!mounted) return;

      // Esta app es solo para clientes.
      if (user.rol != 'CLIENTE') {
        setState(() => _loading = false);
        _aviso('Esta app es solo para clientes.');
        return;
      }

      Session.instance.start(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: user.nombre),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _aviso(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _aviso('No se pudo conectar con el servidor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Iniciar sesión',
      subtitle: 'Qué bueno verte de nuevo.',
      children: [
        AuthTextField(
          label: 'Correo electrónico',
          hint: '123@ejemplo.com',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),

        AuthTextField(
          label: 'Contraseña',
          hint: 'Mínimo 8 caracteres',
          obscureText: true,
          textInputAction: TextInputAction.done,
          controller: passwordController,
        ),

        AuthPrimaryButton(
          label: 'Iniciar Sesión',
          loading: _loading,
          onPressed: iniciarSesion,
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              '¿No tienes cuenta? ',
              style: TextStyle(
                color: AuthColors.textDark,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),

            AuthLink(
              text: 'Crear cuenta',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}