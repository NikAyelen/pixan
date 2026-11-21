import 'package:flutter/material.dart';
import '../services/api_client.dart'; // ApiException
import '../services/session.dart'; // Session
import 'service_flow_widgets.dart';
import 'service_request_data.dart';
import '../services/solicitud_api.dart'; // el archivo nuevo (en lib/services)

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key, required this.request});

  final ServiceRequestData request;

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  bool _enviando = false;

  ServiceRequestData get request => widget.request;

  void _mostrar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _confirmar() async {
    if (_enviando) return; // evita dobles toques

    final user = Session.instance.user;
    if (user == null) {
      _mostrar('Inicia sesión con tu cuenta para enviar la solicitud.');
      return;
    }

    setState(() => _enviando = true);
    try {
      // Guarda el inmueble y la solicitud en la base de datos.
      await SolicitudApi.crear(request, clienteId: user.id);
      if (!mounted) return;
      _mostrar('¡Solicitud confirmada!');
      // Por ahora se regresa al inicio para no enviar la misma solicitud dos veces.
      Navigator.popUntil(context, (route) => route.isFirst);
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrar(e.message);
    } catch (e, st) {
      debugPrint('[quote] ERROR inesperado: $e\n$st');
      if (!mounted) return;
      _mostrar('No se pudo enviar la solicitud. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _editar() {
    if (_enviando) return;
    // Regresa a la pantalla de áreas/extras con todo lo que ya había elegido
    Navigator.popUntil(context, ModalRoute.withName('solicitud'));
  }

  @override
  Widget build(BuildContext context) {
    final extras = request.extras.isEmpty ? 'Ninguno' : request.extras.join(', ');
    final notas = request.notes.isEmpty ? 'Sin notas' : request.notes;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FlowHeader(title: 'Tu cotización'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  children: [
                    // RESUMEN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FlowLabel('Resumen', size: 12),
                          const SizedBox(height: 8),
                          _row('Tipo', request.serviceTitle),
                          _row('Áreas', request.areas.join(', ')),
                          _row('Servicios extras', extras),
                          _row('Notas', notas),
                          _row('Fecha', request.dateText),
                          _row('Hora', request.timeText),
                          if (request.collaborator != null)
                            _row('Colaborador', request.collaborator!),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // PRECIO ESTIMADO
                    Container(
                      width: double.infinity,
                      height: 104,
                      decoration: BoxDecoration(
                        color: FlowColors.teal,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x38000000),
                            blurRadius: 12,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            Positioned(right: 14, top: 8, child: _bubble(34)),
                            Positioned(right: 58, top: 36, child: _bubble(24)),
                            Positioned(right: -4, bottom: 6, child: _bubble(36)),
                            Positioned(right: 50, bottom: -8, child: _bubble(38)),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Precio estimado',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '\$${request.priceMin}-${request.priceMax}',
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '  MXN',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 6),
                                  const SizedBox(
                                    width: 200,
                                    child: Text(
                                      'Calculado según el tipo de limpieza y las áreas elegidas.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // AVISO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: FlowColors.cardGreen,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, size: 14, color: Color(0xFF5B8C5A)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'El precio final lo confirma tu colaborador al revisar el servicio.',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1C1C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTONES
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlowColors.teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _enviando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirmar solicitud',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      onPressed: _editar,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: FlowColors.navy,
                        side: const BorderSide(
                          color: FlowColors.teal,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Editar solicitud',
                        style: TextStyle(
                          fontSize: 10,
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
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: FlowColors.navy,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: FlowColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0x1AFFFFFF), Color(0x33FFFFFF), Color(0x4DFFFFFF)],
        ),
        border: Border.all(color: const Color(0x80FFFFFF), width: 1.5),
      ),
    );
  }
}