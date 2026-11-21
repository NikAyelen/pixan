
import 'package:flutter/material.dart';

// COLORES AUTH
class AuthColors {
  static const Color navy = Color(0xFF2E4054);
  static const Color teal = Color(0xFF46707E);
  static const Color blue = Color(0xFFB7CEDD);
  static const Color beige = Color(0xFFF0EFED);
  static const Color green = Color(0xFF5B8C5A);
  static const Color link = Color(0xFF1F5FBF);
  static const Color uploadFill = Color(0xFFD6E8EF);
  static const Color fieldFill = Color(0xFFE8F3FA);
  static const Color textDark = Color(0xFF1C1C1C);
  static const Color textGrey = Color(0xFF7A7A7A);
  static const Color hintGrey = Color(0xFF8A9199);
  static const Color chevron = Color(0xFF5C7384);
}

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.beige,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuthColors.blue,
              AuthColors.beige,
              AuthColors.beige,
            ],
            stops: [0.0, 0.28, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 30),

                  // ENCABEZADO
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 30,
                          color: AuthColors.chevron,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Historial',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AuthColors.navy,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // SERVICIO ACTUAL
                  _tarjetaActual(),

                  const SizedBox(height: 26),

                  // SERVICIOS PASADOS
                  const Text(
                    'Pasadas',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AuthColors.navy,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _tarjetaPasada(
                    servicio: 'Limpieza general',
                    fecha: '15/10/2026',
                    horario: '10:00 AM',
                  ),

                  const SizedBox(height: 12),

                  _tarjetaPasada(
                    servicio: 'Limpieza profunda',
                    fecha: '10/10/2026',
                    horario: '09:00 AM',
                  ),

                  const SizedBox(height: 12),

                  _tarjetaPasada(
                    servicio: 'Limpieza de cocina',
                    fecha: '05/10/2026',
                    horario: '12:00 PM',
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TARJETA SERVICIO ACTUAL
  Widget _tarjetaActual() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: AuthColors.teal,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AuthColors.blue,
                ),
                child: const Icon(
                  Icons.person,
                  size: 36,
                  color: AuthColors.navy,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'María López',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Horario: 10:00 AM - 12:00 PM',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AuthColors.uploadFill,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Servicio: Limpieza general',
                  style: _datoStyle,
                ),

                SizedBox(height: 3),

                Text(
                  'Fecha: 20/10/2026 | Horario: 10:00 AM',
                  style: _datoStyle,
                ),

                SizedBox(height: 3),

                Text(
                  'Precio: \$350 MXN',
                  style: _datoStyle,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _boton(
                'Eliminar limpieza',
                fondo: AuthColors.navy,
                colorTexto: Colors.white,
              ),

              const SizedBox(width: 8),

              _boton(
                'Editar limpieza',
                fondo: AuthColors.beige,
                colorTexto: AuthColors.navy,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const TextStyle _datoStyle = TextStyle(
    fontSize: 8.5,
    fontWeight: FontWeight.bold,
    color: AuthColors.textDark,
  );

  // BOTONES VISUALES
  Widget _boton(
    String etiqueta, {
    required Color fondo,
    required Color colorTexto,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        etiqueta,
        style: TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.bold,
          color: colorTexto,
        ),
      ),
    );
  }

  // TARJETAS DE SERVICIOS PASADOS
  Widget _tarjetaPasada({
    required String servicio,
    required String fecha,
    required String horario,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AuthColors.fieldFill,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AuthColors.blue,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AuthColors.green,
            ),
            child: const Icon(
              Icons.check,
              size: 18,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  servicio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AuthColors.navy,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  fecha,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AuthColors.textGrey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  horario,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AuthColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              _botonContorno('Reagendar'),

              const SizedBox(height: 5),

              _botonContorno('Reportar'),
            ],
          ),
        ],
      ),
    );
  }

  // BOTONES CON CONTORNO
  Widget _botonContorno(String texto) {
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AuthColors.uploadFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AuthColors.teal,
          width: 1,
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.w700,
          color: AuthColors.navy,
        ),
      ),
    );
  }
}
