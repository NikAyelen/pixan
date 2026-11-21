import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/session.dart';
import 'app_bottom_nav.dart';
import 'chat_screen.dart';
import 'rate_screen.dart';

/// Nombre de respaldo si el backend no manda el nombre del colaborador.
/// Esta pantalla ya usa el nombre real; se deja la constante por si otro
/// archivo todavía la importa.
const String kColaborador = 'Nicte';

/// Una solicitud aceptada por un colaborador.
class _Aviso {
  const _Aviso({
    required this.id,
    required this.colaborador,
    required this.detalle,
  });

  final int id;
  final String colaborador;
  final String detalle;
}

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

  static const Duration _pollEvery = Duration(seconds: 4);

  List<_Aviso> _avisos = const [];
  bool _cargando = true;
  bool _cargandoAhora = false;
  String? _error;
  Timer? _timer;

  // Por solicitud (antes era uno solo para toda la pantalla).
  final Set<int> _leidos = {};
  final Set<int> _calificados = {};

  @override
  void initState() {
    super.initState();
    _cargar();
    _timer = Timer.periodic(_pollEvery, (_) => _cargar());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _cargar() async {
    final clienteId = Session.instance.user?.id;
    if (clienteId == null || _cargandoAhora) {
      if (mounted && _cargando) setState(() => _cargando = false);
      return;
    }
    _cargandoAhora = true;
    try {
      final data = await ApiClient.get('/hoyo-negro?cliente_id=$clienteId');
      final avisos = _parse(data);
      if (!mounted) return;
      setState(() {
        _avisos = avisos;
        _error = null;
        _cargando = false;
      });
    } catch (e, st) {
      debugPrint('[avisos] ERROR: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar tus avisos.';
        _cargando = false;
      });
    } finally {
      _cargandoAhora = false;
    }
  }

  /// Se queda solo con las solicitudes que ya aceptó un colaborador.
  List<_Aviso> _parse(dynamic data) {
    if (data is! List) return const [];
    final out = <_Aviso>[];
    for (final e in data) {
      if (e is! Map) continue;
      if (e['estado'] != 'ACEPTADA') continue;
      final id = e['id'];
      if (id is! int) continue;

      final t = e['trabajador'];
      final nombre = t is Map ? (t['name'] as String?)?.trim() : null;

      final sel = e['seleccion'];
      final tipo = sel is Map ? sel['tipoLimpieza']?.toString() : null;
      DateTime? fecha;
      final rawFecha = e['fecha'];
      if (rawFecha is String) fecha = DateTime.tryParse(rawFecha)?.toLocal();

      final partes = <String>[
        if (tipo != null && tipo.isNotEmpty) tipo,
        if (fecha != null) _fmt(fecha),
      ];

      out.add(_Aviso(
        id: id,
        colaborador:
            (nombre == null || nombre.isEmpty) ? 'Tu colaborador' : nombre,
        detalle: partes.join(' · '),
      ));
    }
    return out;
  }

  String _fmt(DateTime d) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(d.day)}/${dos(d.month)}/${d.year} ${dos(d.hour)}:${dos(d.minute)}';
  }

  void _abrirChat(_Aviso a) {
    setState(() => _leidos.add(a.id));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(nombre: a.colaborador),
      ),
    );
  }

  Future<void> _abrirCalificar(_Aviso a) async {
    final enviado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CalificarScreen(nombre: a.colaborador),
      ),
    );
    if (enviado == true && mounted) {
      setState(() => _calificados.add(a.id));
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
                      ..._contenido(),
                      const SizedBox(height: 20),
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

  List<Widget> _contenido() {
    if (Session.instance.user == null) {
      return [_mensaje('Inicia sesión para ver tus avisos.')];
    }
    if (_cargando) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    final widgets = <Widget>[];
    if (_error != null) {
      widgets.add(_mensaje(_error!));
      widgets.add(const SizedBox(height: 14));
    }
    if (_avisos.isEmpty && _error == null) {
      widgets.add(_mensaje(
          'Cuando un colaborador acepte tu solicitud, te avisaremos aquí.'));
    }
    for (final a in _avisos) {
      widgets.add(_tarjetaConfirmado(a));
      widgets.add(const SizedBox(height: 14));
      widgets.add(_tarjetaCalificar(a));
      widgets.add(const SizedBox(height: 22));
    }
    return widgets;
  }

  Widget _mensaje(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 3),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _grey,
        ),
      ),
    );
  }

  // ─────────────────── TARJETA: SERVICIO CONFIRMADO ───────────────────
  Widget _tarjetaConfirmado(_Aviso a) {
    final leido = _leidos.contains(a.id);
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${a.colaborador} ha confirmado tu servicio',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (!leido)
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
                if (a.detalle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    a.detalle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _grey,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _abrirChat(a),
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
  Widget _tarjetaCalificar(_Aviso a) {
    final calificado = _calificados.contains(a.id);
    return GestureDetector(
      onTap: calificado ? null : () => _abrirCalificar(a),
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
                color: calificado ? _softGreen : _starBg,
              ),
              child: Icon(
                calificado ? Icons.check : Icons.star_border,
                size: 28,
                color: calificado ? _checkColor : _starColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calificado ? 'Servicio calificado' : 'Califica tu servicio',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    calificado
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
            if (!calificado)
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
