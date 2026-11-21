import 'dart:async';
import 'package:app_contratador/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
            colors: [
              Color.fromARGB(255, 255, 255, 255)
            ],
            stops: [0.0, 0.30, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.asset(
                'assets/logoh.jpeg',
                width: 115,
                height: 115,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            
            const Text(
              'AAPPPPPPPPPPPPPP',
              style: TextStyle(
                color: Color(0xFF1C1C1C),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

        
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 70, 112, 126),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}