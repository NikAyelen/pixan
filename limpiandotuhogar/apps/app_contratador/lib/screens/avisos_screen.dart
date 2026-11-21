import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'chat_screen.dart';
import 'rate_screen.dart';

/// Nombre simulado del colaborador. Cámbialo aquí y se actualiza en todo el flujo.
const String kColaborador = 'Nicte';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  State<AvisosScreen> createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
  static const Color _softGreen = Color(0xFFCFE4CC);
  static const Color _checkColor = Color(0xFF4A5A4A);
  static const Color _dotGreen = Color(0xFF5B7A5A);
  static const Color _button = Color(0xFF536F7E);
  static const Color _starBg = Color(0xFFE8F0F8);
  static const Color _starColor = Color(0xFF2F5597);
  static const Color _grey = Color(0xFFA0A0A0);

  bool _leido = false;
  bool _calificado = false;

  void _abrirChat() {
    setState(() => _leido = true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatScreen(nombre: kColaborador),
      ),
    );
  }

  Future<void> _abrirCalificar() async {
    final enviado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const CalificarScreen(nombre: kColaborador),
      ),
    );
    if (enviado == true && mounted) {
      setState(() => _calificado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Gracias por tu calificación!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'Avisos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 3, top: 2),
                        child: Text(
                          'Hoy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _tarjetaConfirmado(),
                      const SizedBox(height: 14),
                      _tarjetaCalificar(),
                    ],
                  ),
                ),
              ),
            ),
            const AppBottomNav(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  // ─────────────────── TARJETA: SERVICIO CONFIRMADO ───────────────────
  Widget _tarjetaConfirmado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _softGreen,
            ),
            child: const Icon(Icons.check, size: 28, color: _checkColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '$kColaborador ha confirmado tu servicio',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (!_leido)
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 8),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _dotGreen,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _abrirChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _button,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 9),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Mensaje',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── TARJETA: CALIFICA TU SERVICIO ───────────────────
  Widget _tarjetaCalificar() {
    return GestureDetector(
      onTap: _calificado ? null : _abrirCalificar,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _calificado ? _softGreen : _starBg,
              ),
              child: Icon(
                _calificado ? Icons.check : Icons.star_border,
                size: 28,
                color: _calificado ? _checkColor : _starColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _calificado ? 'Servicio calificado' : 'Califica tu servicio',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _calificado
                        ? 'Gracias por tus comentarios'
                        : 'Cuéntanos cómo te fue',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!_calificado)
              const Icon(Icons.chevron_right, size: 28, color: Colors.black),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    );
  }
}