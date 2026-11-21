import 'package:flutter/material.dart';

class FlowColors {
  static const Color navy = Color(0xFF2E4054);
  static const Color teal = Color(0xFF46707E);
  static const Color lightBlue = Color(0xFFE8F3FA);
  static const Color cardGreen = Color(0xFFDDEBDA);
  static const Color greenSelected = Color(0xFFCFE8C8);
  static const Color greenBorder = Color(0xFFB9D8B3);
  static const Color chevron = Color(0xFF5C7384);
  static const Color textGrey = Color(0xFF7A7A7A);
}

/// Flecha de regreso + título de la pantalla.
class FlowHeader extends StatelessWidget {
  const FlowHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 20, 8),
      child: Row(
        children: [
          InkResponse(
            onTap: () => Navigator.maybePop(context),
            radius: 24,
            child: const Icon(
              Icons.chevron_left,
              size: 38,
              color: FlowColors.chevron,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: FlowColors.navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Texto de sección en negritas (ej. "¿Qué áreas deseas limpiar?").
class FlowLabel extends StatelessWidget {
  const FlowLabel(this.text, {super.key, this.size = 12});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: FlowColors.navy,
        fontSize: size,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

/// Opción seleccionable. [green] = estilo verde para servicios extra.
class FlowChip extends StatelessWidget {
  const FlowChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.green = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final Color fill = selected
        ? (green ? FlowColors.greenSelected : FlowColors.teal)
        : Colors.white;
    final Color border = green ? FlowColors.greenBorder : FlowColors.teal;
    final Color text = selected && !green ? Colors.white : FlowColors.navy;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1.3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            color: text,
          ),
        ),
      ),
    );
  }
}

/// Botón "Ok" pequeño que confirma una sección.
class FlowOkButton extends StatelessWidget {
  const FlowOkButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: FlowColors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(52, 28),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Ok',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }
}