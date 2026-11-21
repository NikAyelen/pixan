import 'package:flutter/material.dart';

import 'schedule_dialog.dart';
import 'service_flow_widgets.dart';
import 'service_request_data.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({
    super.key,
    required this.serviceTitle,
    required this.price,
    required this.image,
    required this.basePrice,
    this.property = const PropertyData(),
  });

  final String serviceTitle;
  final String price; // ej. "Desde $400"
  final String image;
  final int basePrice; // ej. 400

  /// Datos del inmueble y dirección capturados en «Datos del inmueble».
  final PropertyData property;

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  static const List<String> areas = [
    'Cocina',
    'Sala',
    'Recámaras',
    'Baños',
    'Patio',
    'Áreas comunes',
  ];

  static const Map<String, int> extras = {
    'Limpieza de ventanas': 300,
    'Limpieza de estufa': 300,
    'Limpieza de refrigerador': 200,
    'Limpieza de alacena': 180,
    'Limpieza de cajonera': 150,
  };

  final Set<String> areasSel = {};
  final Set<String> extrasSel = {};
  final TextEditingController notasController = TextEditingController();

  @override
  void dispose() {
    notasController.dispose();
    super.dispose();
  }

  bool get _todaLaCasa => areasSel.length == areas.length;

  void _toggleArea(String area) {
    setState(() {
      if (areasSel.contains(area)) {
        areasSel.remove(area);
      } else {
        areasSel.add(area);
      }
    });
  }

  void _toggleTodaLaCasa() {
    setState(() {
      if (_todaLaCasa) {
        areasSel.clear();
      } else {
        areasSel.addAll(areas);
      }
    });
  }

  void _toggleExtra(String extra) {
    setState(() {
      if (extrasSel.contains(extra)) {
        extrasSel.remove(extra);
      } else {
        extrasSel.add(extra);
      }
    });
  }

  // Fórmula de ejemplo: base + $25 por área + extras (rango de +$100).
  // Ajústala cuando haya base de datos.
  int get _extrasTotal =>
      extrasSel.fold<int>(0, (suma, e) => suma + (extras[e] ?? 0));
  int get _precioMin => widget.basePrice + areasSel.length * 25 + _extrasTotal;
  int get _precioMax => _precioMin + 100;

  void _enviar() {
    if (areasSel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige al menos un área para limpiar')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final request = ServiceRequestData(
      serviceTitle: widget.serviceTitle,
      areas: areas.where(areasSel.contains).toList(),
      extras: extras.keys.where(extrasSel.contains).toList(),
      notes: notasController.text.trim(),
      priceMin: _precioMin,
      priceMax: _precioMax,
      extrasTotal: _extrasTotal,
      property: widget.property,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x66000000),
      builder: (_) => ScheduleDialog(
        serviceTitle: widget.serviceTitle,
        price: widget.price,
        image: widget.image,
        request: request,
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
                    // ÁREAS
                    const FlowLabel('¿Qué áreas deseas limpiar?', size: 12),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final area in areas)
                          FlowChip(
                            label: area,
                            selected: areasSel.contains(area),
                            onTap: () => _toggleArea(area),
                          ),
                        FlowChip(
                          label: 'Toda la casa',
                          selected: _todaLaCasa,
                          onTap: _toggleTodaLaCasa,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // EXTRAS
                    const FlowLabel('¿Desea un servicio extra?', size: 12),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final extra in extras.keys)
                          FlowChip(
                            label: '$extra \$${extras[extra]}',
                            selected: extrasSel.contains(extra),
                            green: true,
                            onTap: () => _toggleExtra(extra),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // NOTAS
                    const FlowLabel('¿Hay algo que debemos saber?', size: 12),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: notasController,
                        maxLines: 6,
                        cursorColor: FlowColors.teal,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1C1C1C),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Mascotas, acceso al domicilio, productos de limpieza que prefieres...',
                          hintStyle: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8A9199),
                          ),
                          filled: true,
                          fillColor: FlowColors.lightBlue,
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: FlowColors.teal,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: FlowColors.teal,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BARRA DE PRECIO
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 20, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F4F6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 14,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Precio estimado',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: FlowColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\$$_precioMin-$_precioMax',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: FlowColors.navy,
                                ),
                              ),
                              const TextSpan(
                                text: '  MXN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: FlowColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      onPressed: _enviar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlowColors.teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Enviar solicitud!',
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
}