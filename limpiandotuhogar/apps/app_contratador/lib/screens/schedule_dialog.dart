import 'package:flutter/material.dart';

import 'collaborators_screen.dart';
import 'quote_screen.dart';
import 'service_flow_widgets.dart';
import 'service_request_data.dart';

class ScheduleDialog extends StatefulWidget {
  const ScheduleDialog({
    super.key,
    required this.serviceTitle,
    required this.price,
    required this.image,
    required this.request,
  });

  final String serviceTitle;
  final String price; // ej. "Desde $400"
  final String image;
  final ServiceRequestData request;

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  static const Duration _anim = Duration(milliseconds: 300);

  static const String _msgFalta = 'Elige horario y fecha para continuar';
  static const String _msgPasado =
      'Elige una fecha y hora que aún no hayan pasado';

  TimeOfDay? time;
  DateTime? date;
  bool scheduleOpen = true; // sección de horario y fecha abierta
  bool confirmed = false; // ya dio Ok -> aparece la elección de colaborador
  bool showError = false;
  String errorMsg = _msgFalta;

  Widget _themed(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: FlowColors.teal,
          onPrimary: Colors.white,
          onSurface: FlowColors.navy,
        ),
      ),
      child: child!,
    );
  }

  String _fmtTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = (d.year % 100).toString().padLeft(2, '0');
    return '$dd/$mm/$yy';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: time ?? const TimeOfDay(hour: 9, minute: 0),
      builder: _themed,
    );
    if (picked != null && mounted) {
      setState(() {
        time = picked;
        showError = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
      builder: _themed,
    );
    if (picked != null && mounted) {
      setState(() {
        date = picked;
        showError = false;
      });
    }
  }

  void _confirmar() {
    final d = date;
    final t = time;
    if (t == null || d == null) {
      setState(() {
        showError = true;
        errorMsg = _msgFalta;
      });
      return;
    }

    // La fecha y hora combinadas deben ser futuras: si no, el trabajador
    // no podría aceptar la solicitud.
    final fecha = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    if (!fecha.isAfter(DateTime.now())) {
      setState(() {
        showError = true;
        errorMsg = _msgPasado;
      });
      return;
    }

    setState(() {
      showError = false;
      confirmed = true;
      scheduleOpen = false; // se oculta con animación
    });
  }

  void _elegir(Widget Function(ServiceRequestData data) crearPantalla) {
    final data = widget.request.copyWith(date: date, time: time);
    final nav = Navigator.of(context);
    nav.pop(); // cierra el diálogo
    nav.push(MaterialPageRoute(builder: (_) => crearPantalla(data)));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: foto + título + precio
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const ColoredBox(
                            color: FlowColors.teal,
                            child: Icon(
                              Icons.cleaning_services,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: FlowColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFDDDDDD)),
              const SizedBox(height: 14),

              // ── HORARIO Y FECHA ──
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: confirmed
                    ? () => setState(() => scheduleOpen = !scheduleOpen)
                    : null,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Elige horario y fecha de tu limpieza',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (confirmed)
                      AnimatedRotation(
                        turns: scheduleOpen ? 0.5 : 0,
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
              AnimatedCrossFade(
                duration: _anim,
                sizeCurve: Curves.easeInOut,
                crossFadeState: scheduleOpen
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _scheduleContent(),
                secondChild: const SizedBox(width: double.infinity),
              ),

              // ── ELECCIÓN DE COLABORADOR (aparece tras el Ok) ──
              AnimatedCrossFade(
                duration: _anim,
                sizeCurve: Curves.easeInOut,
                crossFadeState: confirmed
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: _collaboratorSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scheduleContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _field(
                  label: 'Horario',
                  value: time == null ? '00:00' : _fmtTime(time!),
                  filled: time != null,
                  onTap: _pickTime,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _field(
                  label: 'Fecha',
                  value: date == null ? '00/00/00' : _fmtDate(date!),
                  filled: date != null,
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
              ),
            ],
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMsg,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC0392B),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FlowOkButton(onPressed: _confirmar),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required String value,
    required bool filled,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: FlowColors.teal,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: FlowColors.lightBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: filled ? FlowColors.navy : const Color(0xFF8A9199),
                    ),
                  ),
                ),
                if (icon != null) Icon(icon, size: 14, color: FlowColors.navy),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _collaboratorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        const Text(
          '¿Cómo quieres elegir a tu colaborador?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),

        // Opción 1: Elegir personalmente
        _opcion(
          icon: Icons.person_outline,
          title: 'Elegir personalmente',
          subtitle: 'Revisa perfiles y escoge a quien prefieras',
          filled: false,
          onTap: () => _elegir((data) => CollaboratorsScreen(request: data)),
        ),
        const SizedBox(height: 14),

        // Opción 2: Asignación automática
        Stack(
          clipBehavior: Clip.none,
          children: [
            _opcion(
              icon: Icons.auto_awesome,
              title: 'Asignación automática',
              subtitle: 'Te asignamos a alguien disponible',
              filled: true,
              onTap: () => _elegir((data) => QuoteScreen(request: data)),
            ),
            Positioned(
              top: -8,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: FlowColors.cardGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Más rápido',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3C6B35),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _opcion({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool filled,
    required VoidCallback onTap,
  }) {
    final Color textColor = filled ? Colors.white : FlowColors.navy;
    final Color subColor = filled ? Colors.white70 : const Color(0xFF777777);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: filled ? FlowColors.teal : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border:
              filled ? null : Border.all(color: FlowColors.teal, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? const Color(0xFF5E8795) : FlowColors.lightBlue,
              ),
              child: Icon(
                icon,
                size: 20,
                color: filled ? Colors.white : FlowColors.navy,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: subColor,
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
