import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _ineFront = false;
  bool _ineBack = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_ineFront || !_ineBack) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sube el frente y el reverso de tu INE')),
      );
      return;
    }
    // TODO: conectar con el backend (POST /auth/register)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cuenta creada')),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
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
              SizedBox(height: h * 0.1),
              Row(
                children: [
                  const BackArrow(),
                  Expanded(
                    child: Text(
                      '¡Crea tu cuenta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: w * 0.083,
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              Center(
                child: Text(
                  'Ingresa tu información personal.',
                  style: TextStyle(
                    fontSize: w * 0.044,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),
              AuthField(
                label: 'Nombre',
                hint: 'Tu nombre',
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa tu nombre'
                    : null,
              ),
              const SizedBox(height: 18),
              AuthField(
                label: 'Número telefónico',
                hint: '10 dígitos',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) =>
                    (v == null || v.length != 10) ? 'Deben ser 10 dígitos' : null,
              ),
              const SizedBox(height: 18),
              AuthField(
                label: 'Correo electrónico',
                hint: '123@ejemplo.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Ingresa tu correo';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                    return 'Correo no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              AuthField(
                label: 'Contraseña',
                hint: 'Mínimo 8 caracteres',
                controller: _passCtrl,
                obscure: true,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.length < 8) ? 'Mínimo 8 caracteres' : null,
              ),
              const SizedBox(height: 18),
              AuthField(
                label: 'Confirmar contraseña',
                hint: 'Repite tu contraseña',
                controller: _confirmCtrl,
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    v != _passCtrl.text ? 'Las contraseñas no coinciden' : null,
              ),
              const SizedBox(height: 26),
              const Center(
                child: Text(
                  'Identificación oficial (INE)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _UploadBox(
                      label: 'Subir frente',
                      done: _ineFront,
                      onTap: () => setState(() => _ineFront = !_ineFront),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _UploadBox(
                      label: 'Subir reverso',
                      done: _ineBack,
                      onTap: () => setState(() => _ineBack = !_ineBack),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              AuthButton.primary('Crear cuenta', _submit),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String label;
  final bool done;
  final VoidCallback onTap;

  const _UploadBox({
    required this.label,
    required this.done,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.58,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.uploadBorder, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                done ? Icons.check_circle_outline : Icons.upload_outlined,
                size: 32,
                color: AppColors.dark,
              ),
              const SizedBox(height: 8),
              Text(
                done ? 'Listo' : label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}