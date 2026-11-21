import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'collaborators_screen.dart';
import 'quote_screen.dart';
import 'service_flow_widgets.dart';
import 'service_request_data.dart';

class CollaboratorProfileScreen extends StatelessWidget {
  const CollaboratorProfileScreen({
    super.key,
    required this.request,
    required this.collaborator,
  });

  final ServiceRequestData request;
  final Collaborator collaborator;

  void _enviarSolicitud(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuoteScreen(
          request: request.copyWith(collaborator: collaborator.nombre),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FlowHeader(title: ''),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: FlowColors.cardGreen,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      collaborator.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1C1C1C),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // ESPECIALIDADES
                    _infoCard(
                      title: 'Especialidades',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          for (final e in collaborator.especialidades)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: FlowColors.lightBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: FlowColors.navy,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // HORARIOS
                    _infoCard(
                      title: 'Horarios',
                      child: Row(
                        children: [
                          Text(
                            collaborator.dias,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: FlowColors.teal,
                            ),
                          ),
                          const SizedBox(width: 28),
                          Text(
                            collaborator.horario,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: FlowColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _enviarSolicitud(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlowColors.teal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Enviar solicitud',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
          FlowLabel(title, size: 11),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}