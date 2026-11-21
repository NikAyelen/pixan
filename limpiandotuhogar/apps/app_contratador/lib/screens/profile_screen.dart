import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';
import 'historial_screen.dart';
import 'welcome_screen.dart';

// PALETA DE COLORES AUTH
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

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {

  // DATOS DEL USUARIO
  final TextEditingController nombre =
      TextEditingController(text: 'Usuario');

  final TextEditingController telefono =
      TextEditingController(text: '1234567891');

  final TextEditingController correo =
      TextEditingController(text: 'abcd@ejemplo.com');

  String nombreMostrado = 'Usario';

  @override
  void dispose() {
    nombre.dispose();
    telefono.dispose();
    correo.dispose();
    super.dispose();
  }

  // GUARDAR CAMBIOS
  void _guardar() {
    FocusScope.of(context).unfocus();

    if (nombre.text.trim().isEmpty ||
        telefono.text.trim().isEmpty ||
        correo.text.trim().isEmpty) {
      _aviso('Completa todos los campos');
      return;
    }

    if (!correo.text.contains('@')) {
      _aviso('Escribe un correo válido');
      return;
    }

    setState(() => nombreMostrado = nombre.text.trim());

    _aviso('Cambios guardados');
  }

  // MOSTRAR AVISOS
  void _aviso(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.beige,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuthColors.blue,
              AuthColors.beige,
              AuthColors.beige,
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 40),

                        // BOTÓN HISTORIAL
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            const Text(
                              'Mi perfil',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AuthColors.navy,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const HistorialScreen(),
                                  ),
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(
                                  color: AuthColors.teal,
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),

                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Icon(
                                      Icons.history,
                                      size: 11,
                                      color: Colors.white,
                                    ),

                                    SizedBox(width: 4),

                                    Text(
                                      'Historial',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // FOTO DE PERFIL
                        Center(
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuthColors.green,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // NOMBRE
                        Center(
                          child: Text(
                            nombreMostrado,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AuthColors.navy,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // CAMPOS
                        _campo(
                          'Nombre',
                          nombre,
                          TextInputType.name,
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          'Número telefónico',
                          telefono,
                          TextInputType.phone,
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          'Correo electrónico',
                          correo,
                          TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 14),

                        // INE
                        _barraIne(),

                        const SizedBox(height: 30),

                        // BOTÓN GUARDAR
                        GestureDetector(
                          onTap: _guardar,

                          child: Container(
                            width: double.infinity,

                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),

                            alignment: Alignment.center,

                            decoration: BoxDecoration(
                              color: AuthColors.teal,
                              borderRadius:
                                  BorderRadius.circular(22),

                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),

                            child: const Text(
                              'Guardar cambios',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                  
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // BARRA DE NAVEGACIÓN
              const AppBottomNav(currentIndex: 3),
            ],
          ),
        ),
      ),
    );
  }

  // CAMPOS DE TEXTO
  Widget _campo(
    String etiqueta,
    TextEditingController controller,
    TextInputType tipo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          etiqueta,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: AuthColors.navy,
          ),
        ),

        const SizedBox(height: 5),

        Container(
          height: 36,

          decoration: BoxDecoration(
            color: AuthColors.fieldFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AuthColors.teal,
              width: 1.2,
            ),
          ),

          child: TextField(
            controller: controller,
            keyboardType: tipo,
            cursorColor: AuthColors.teal,

            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AuthColors.textDark,
            ),

            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // BARRA INE
  Widget _barraIne() {
    return Container(
      height: 40,

      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: BoxDecoration(
        color: AuthColors.teal,
        borderRadius: BorderRadius.circular(12),

        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          const Icon(
            Icons.badge_outlined,
            size: 14,
            color: Colors.white,
          ),

          const SizedBox(width: 8),

          const Text(
            'INE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),

            decoration: BoxDecoration(
              color: AuthColors.green,
              borderRadius: BorderRadius.circular(8),
            ),

            child: const Text(
              'Verificada',
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}