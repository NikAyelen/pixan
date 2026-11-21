import 'package:flutter/material.dart';
import 'package:app_contratador/screens/login_screen.dart';
import 'package:app_contratador/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _navy = Color(0xFF2E4054);
  static const Color _bgBlue = Color(0xFFB7CEDD);
  static const Color _bgBeige = Color(0xFFF0EFED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgBlue, _bgBeige, _bgBeige],
            stops: [0.0, 0.30, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                     
                      const Spacer(flex: 3),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.asset(
                          'assets/logoH.jpeg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'APPP',
                        style: TextStyle(
                          color: Color(0xFF1C1C1C),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Reserva limpieza para tu hogar en pocos pasos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7A7A7A),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),

                      // Espacio entre el texto y los botones
                      const Spacer(flex: 2),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            _WelcomeButton(
                              label: 'Iniciar sesión',
                              backgroundColor: Color.fromARGB(
                                255,
                                70,
                                112,
                                126,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            _WelcomeButton(
                              label: 'Crear cuenta',
                              backgroundColor: Colors.white,
                              foregroundColor: _navy,
                              borderColor: const Color.fromARGB(
                                255,
                                70,
                                112,
                                126,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Margen inferior, como en la imagen
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
    this.foregroundColor = Colors.white,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
