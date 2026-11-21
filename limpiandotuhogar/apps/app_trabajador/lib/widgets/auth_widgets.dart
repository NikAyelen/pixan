import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'foam_overlay.dart';

class WavePainter extends CustomPainter {
  final bool bottomWaves;
  const WavePainter({this.bottomWaves = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.background);

    if (bottomWaves) {
      final light = Path()
        ..moveTo(0, h * 0.885)
        ..cubicTo(w * 0.20, h * 0.875, w * 0.33, h * 0.915, w * 0.47, h * 0.865)
        ..cubicTo(w * 0.55, h * 0.835, w * 0.58, h * 0.77, w * 0.70, h * 0.745)
        ..cubicTo(w * 0.88, h * 0.72, w * 0.95, h * 0.67, w, h * 0.63)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close();
      canvas.drawPath(light, Paint()..color = AppColors.waveLight);

      final mid = Path()
        ..moveTo(w * 0.20, h)
        ..cubicTo(w * 0.30, h * 0.955, w * 0.50, h * 0.96, w * 0.62, h * 0.93)
        ..cubicTo(w * 0.80, h * 0.89, w * 0.78, h * 0.75, w * 0.90, h * 0.735)
        ..cubicTo(w * 0.95, h * 0.73, w * 0.98, h * 0.74, w, h * 0.745)
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(mid, Paint()..color = AppColors.waveMid);

      final dark = Path()
        ..moveTo(w * 0.57, h)
        ..cubicTo(w * 0.65, h * 0.975, w * 0.82, h * 0.965, w * 0.90, h * 0.90)
        ..cubicTo(w * 0.95, h * 0.85, w * 0.96, h * 0.77, w, h * 0.76)
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(dark, Paint()..color = AppColors.waveDark);
    }

    final header = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h * 0.409)
      ..cubicTo(w * 0.20, h * 0.42, w * 0.30, h * 0.385, w * 0.435, h * 0.36)
      ..cubicTo(w * 0.60, h * 0.33, w * 0.80, h * 0.30, w, h * 0.314)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(header, Paint()..color = AppColors.sky);
  }

  @override
  bool shouldRepaint(covariant WavePainter old) =>
      old.bottomWaves != bottomWaves;
}

class AuthShell extends StatelessWidget {
  final bool bottomWaves;
  final Widget Function(BuildContext context, double w, double h) builder;

  const AuthShell({super.key, required this.builder, this.bottomWaves = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight + MediaQuery.viewInsetsOf(context).bottom;
          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: w,
                height: h,
                child: CustomPaint(
                  painter: WavePainter(bottomWaves: bottomWaves),
                ),
              ),
              const Positioned.fill(
                child: IgnorePointer(child: FoamOverlay()),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight),
                    child: builder(context, w, h),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.08),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset('assets/logo.png', fit: BoxFit.contain),
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  final double w;
  final double h;
  const BrandHeader({super.key, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: h * 0.12),
        AppLogo(size: w * 0.483),
        SizedBox(height: h * 0.004),
        Text(
          AppColors.appName,
          style: TextStyle(
            fontSize: w * 0.155,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final bool shadow;
  final bool loading;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
    this.shadow = false,
    this.loading = false,
  });

  factory AuthButton.primary(String label, VoidCallback? onPressed,
          {bool loading = false}) =>
      AuthButton(
        label: label,
        onPressed: onPressed,
        background: AppColors.primary,
        foreground: Colors.white,
        loading: loading,
      );

  factory AuthButton.light(String label, VoidCallback? onPressed) =>
      AuthButton(
        label: label,
        onPressed: onPressed,
        background: AppColors.lightButton,
        foreground: AppColors.dark,
        shadow: true,
      );

  factory AuthButton.white(String label, VoidCallback? onPressed) =>
      AuthButton(
        label: label,
        onPressed: onPressed,
        background: Colors.white,
        foreground: AppColors.dark,
        shadow: true,
      );

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(40);
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        boxShadow: shadow ? AppColors.softShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: foreground,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: foreground,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double size;

  const LinkText(this.text, {super.key, this.onTap, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w800,
          color: AppColors.link,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.link,
        ),
      ),
    );
  }
}

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: const Icon(Icons.arrow_back_ios_new,
          size: 26, color: AppColors.primary),
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}

class AuthField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const AuthField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.suffix,
    this.onSubmitted,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: color, width: width),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: AppColors.softShadow,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onSubmitted,
            validator: validator,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.dark,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.hint,
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffix,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
              border: border(AppColors.border),
              enabledBorder: border(AppColors.border),
              focusedBorder: border(AppColors.primary, 1.5),
              errorBorder: border(Colors.redAccent),
              focusedErrorBorder: border(Colors.redAccent, 1.5),
              errorStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}