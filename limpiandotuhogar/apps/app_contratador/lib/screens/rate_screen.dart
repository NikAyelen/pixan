import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

class CalificarScreen extends StatefulWidget {
  const CalificarScreen({super.key, this.nombre = 'Colaborador'});

  final String nombre;

  @override
  State<CalificarScreen> createState() => _CalificarScreenState();
}

class _CalificarScreenState extends State<CalificarScreen> {
  static const Color _teal = Color(0xFF46707E);
  static const Color _avatar = Color(0xFFCFE4CC);
  static const Color _chevron = Color(0xFF5C7384);
  static const Color _fieldFill = Color(0xFFE8F0F8);
  static const Color _fieldBorder = Color(0xFF7F97A5);
  static const Color _broomOff = Color(0xFF2B2B2B);

  int _rating = 0;
  final TextEditingController _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  void _enviar() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige de 1 a 5 escobas')),
      );
      return;
    }
    // Simulado: no se guarda nada, solo regresa a Avisos
    FocusScope.of(context).unfocus();
    Navigator.pop(context, true);
  }

  Widget _escobas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final activa = i < _rating;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _rating = i + 1),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.cleaning_services_outlined,
              size: 42,
              color: activa ? _teal : _broomOff,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkResponse(
                onTap: () => Navigator.maybePop(context),
                radius: 24,
                child: const Icon(Icons.chevron_left,
                    size: 40, color: _chevron),
              ),
              const SizedBox(height: 22),
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: _avatar,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.nombre,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text(
                  'Califica tu servicio',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _escobas(),
              const SizedBox(height: 26),
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text(
                  'Cuéntanos cómo te fue',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 12,
                      offset: Offset(4, 8),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _comentario,
                  minLines: 7,
                  maxLines: 7,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: _teal,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _fieldFill,
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: _fieldBorder, width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: _teal, width: 3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _enviar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Enviar calificación',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: AppBottomNav(currentIndex: 2),
      ),
    );
  }
}