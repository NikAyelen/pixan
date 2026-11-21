import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'collaborator_profile_screen.dart';
import 'service_flow_widgets.dart';
import 'service_request_data.dart';

class Collaborator {
  const Collaborator({
    required this.nombre,
    required this.inicio,
    required this.fin,
    required this.dias,
    required this.especialidades,
  });

  final String nombre;
  final int inicio; // hora de entrada (formato 24 h)
  final int fin; // hora de salida (formato 24 h)
  final String dias;
  final List<String> especialidades;

  static String _hora(int h) {
    final h12 = h % 12 == 0 ? 12 : h % 12;
    final periodo = h < 12 ? 'am' : 'pm';
    return '$h12:00$periodo';
  }

  String get horario => '${_hora(inicio)}-${_hora(fin)}';
}

class CollaboratorsScreen extends StatefulWidget {
  const CollaboratorsScreen({super.key, required this.request});

  final ServiceRequestData request;

  @override
  State<CollaboratorsScreen> createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  static const List<String> filtros = ['Cualquier horario', 'Mañana', 'Tarde'];

  // Datos de ejemplo, en lo que se agrega la base de datos
  static const List<Collaborator> colaboradores = [
    Collaborator(
      nombre: 'Ana López',
      inicio: 8,
      fin: 15,
      dias: 'Lunes-Sábado',
      especialidades: ['Limpieza profunda', 'Cocina'],
    ),
    Collaborator(
      nombre: 'Carlos Ruiz',
      inicio: 9,
      fin: 18,
      dias: 'Lunes-Sábado',
      especialidades: ['Limpieza regular', 'Baños'],
    ),
    Collaborator(
      nombre: 'María Pérez',
      inicio: 13,
      fin: 20,
      dias: 'Lunes-Viernes',
      especialidades: ['Limpieza post-obra', 'Patio'],
    ),
    Collaborator(
      nombre: 'Luis Hernández',
      inicio: 7,
      fin: 13,
      dias: 'Lunes-Sábado',
      especialidades: ['Limpieza regular', 'Recámaras'],
    ),
    Collaborator(
      nombre: 'Sofía Ramírez',
      inicio: 12,
      fin: 19,
      dias: 'Martes-Sábado',
      especialidades: ['Limpieza profunda', 'Áreas comunes'],
    ),
  ];

  String filtro = filtros.first;

  List<Collaborator> get _visibles {
    switch (filtro) {
      case 'Mañana':
        return colaboradores.where((c) => c.inicio < 12).toList();
      case 'Tarde':
        return colaboradores.where((c) => c.fin > 12).toList();
      default:
        return colaboradores;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _visibles;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FlowHeader(title: 'Colaboradores'),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FlowLabel('Elige a tu colaborador', size: 10),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in filtros)
                        FlowChip(
                          label: f,
                          selected: filtro == f,
                          onTap: () => setState(() => filtro = f),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: visibles.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay colaboradores en ese horario',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: FlowColors.textGrey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                      itemCount: visibles.length,
                      itemBuilder: (context, i) => _card(visibles[i]),
                    ),
            ),

            const AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _card(Collaborator c) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CollaboratorProfileScreen(
              request: widget.request,
              collaborator: c,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E000000),
              blurRadius: 14,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: FlowColors.cardGreen,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.nombre,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: FlowColors.navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Horario: ${c.horario}',
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF444444),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 24, color: Colors.black),
          ],
        ),
      ),
    );
  }
}