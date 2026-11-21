import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: conectar con el backend (POST /auth/forgot-password)
    setState(() => _sent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enlace enviado a tu correo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      builder: (context, w, h) => Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.09),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.075),
              const BackArrow(),
              SizedBox(height: h * 0.035),
              Center(
                child: Text(
                  'Recuperar contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: w * 0.083,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Te enviaremos un enlace a tu correo para\ncrear una nueva contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: h * 0.115),
              AuthField(
                label: 'Correo electrónico',
                hint: 'abcde@ejemplo.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _send(),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Ingresa tu correo';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                    return 'Correo no válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: h * 0.04),
              AuthButton.primary('Enviar enlace', _send),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 22),
                  child: LinkText(
                    'Enviar otro enlace',
                    onTap: _sent ? _send : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}