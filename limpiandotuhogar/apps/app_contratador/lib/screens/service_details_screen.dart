import 'package:flutter/material.dart';

import 'service_flow_widgets.dart';
import 'service_request_screen.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({
    super.key,
    required this.serviceTitle,
    required this.price,
    required this.image,
    required this.basePrice,
  });

  final String serviceTitle;
  final String price; // ej. "Desde $400"
  final String image;
  final int basePrice; // ej. 400

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  static const List<String> tiposCasa = ['Casa', 'Oficina', 'Departamento'];

  static const List<String> secciones = [
    'Número de habitaciones',
    'Número de baños completos',
    'Número de medios baños',
    'Número de pisos o niveles',
  ];

  // Mínimo de cada sección (los pisos empiezan en 1)
  static const List<int> minimos = [0, 0, 0, 1];

  String tipoCasa = 'Casa';
  final List<int> cantidades = [0, 0, 0, 1];
  final List<bool> abiertas = [true, false, false, false];
  final List<bool> confirmadas = [false, false, false, false];

  void _confirmar(int i) {
    setState(() {
      confirmadas[i] = true;
      abiertas[i] = false; // se oculta con animación
    });
  }

  void _continuar({required bool guardar}) {
    if (guardar) {
      // TODO: guardar los datos del inmueble cuando exista la base de datos
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: 'solicitud'),
        builder: (_) => ServiceRequestScreen(
          serviceTitle: widget.serviceTitle,
          price: widget.price,
          image: widget.image,
          basePrice: widget.basePrice,
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
            FlowHeader(title: widget.serviceTitle),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FlowLabel('Datos del inmueble', size: 11),
                    const SizedBox(height: 14),
                    const FlowLabel('Tipo de casa', size: 13),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tipo in tiposCasa)
                          FlowChip(
                            label: tipo,
                            selected: tipoCasa == tipo,
                            onTap: () => setState(() => tipoCasa = tipo),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    for (int i = 0; i < secciones.length; i++)
                      _ExpandableCard(
                        title: secciones[i],
                        expanded: abiertas[i],
                        summary: confirmadas[i] ? '${cantidades[i]}' : null,
                        onToggle: () =>
                            setState(() => abiertas[i] = !abiertas[i]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _Counter(
                              value: cantidades[i],
                              min: minimos[i],
                              onChanged: (v) =>
                                  setState(() => cantidades[i] = v),
                            ),
                            FlowOkButton(onPressed: () => _confirmar(i)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => _continuar(guardar: false),
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
                          'Continuar',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _continuar(guardar: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlowColors.teal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Continuar y guardar',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
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
}

/// Tarjeta que se abre y se cierra con animación.
class _ExpandableCard extends StatelessWidget {
  const _ExpandableCard({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.summary,
  });

  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final String? summary; // valor elegido, se ve cuando está cerrada

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(child: FlowLabel(title, size: 12)),
                  if (summary != null && !expanded)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        summary!,
                        style: const TextStyle(
                          color: FlowColors.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                      color: FlowColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: child,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// Número con flechas arriba/abajo.
class _Counter extends StatelessWidget {
  const _Counter({
    required this.value,
    required this.min,
    required this.onChanged,
  });

  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  static const int _max = 20;

  @override
  Widget build(BuildContext context) {
    final bool canDown = value > min;
    final bool canUp = value < _max;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: FlowColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: FlowColors.navy,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: canUp ? () => onChanged(value + 1) : null,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 18,
                  color: canUp ? FlowColors.navy : Colors.black26,
                ),
              ),
              GestureDetector(
                onTap: canDown ? () => onChanged(value - 1) : null,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: canDown ? FlowColors.navy : Colors.black26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}