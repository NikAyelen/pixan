import 'package:flutter/material.dart';

class _Msg {
  const _Msg(this.texto, {required this.mio, this.saludo = false});

  final String texto;
  final bool mio;
  final bool saludo; // el primer mensaje lleva el nombre en cursiva
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.nombre = 'Colaborador'});

  final String nombre;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color _headerBg = Color(0xFFE8F3FA);
  static const Color _chevron = Color(0xFF5C7384);
  static const Color _teal = Color(0xFF46707E);
  static const Color _avatar = Color(0xFFCFE4CC);
  static const Color _recibido = Color(0xFFD3DEE6);
  static const Color _enviado = Color(0xFF5B7886);
  static const Color _chip = Color(0xFFD3E6D0);
  static const Color _enviarBtn = Color(0xFF2F5597);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<_Msg> _mensajes = [
    const _Msg('', mio: false, saludo: true),
    const _Msg('Hola. Tengo dos mascotas en casa, solo para avisar.',
        mio: true),
    const _Msg('Perfecto, lo tomo en cuenta', mio: false),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _bajar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  /// Agrega mi mensaje y simula la respuesta del colaborador
  void _enviar(String texto, {String? respuesta}) {
    final t = texto.trim();
    if (t.isEmpty) return;

    setState(() => _mensajes.add(_Msg(t, mio: true)));
    _controller.clear();
    _bajar();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _mensajes.add(
          _Msg(respuesta ?? 'Perfecto, lo tomo en cuenta', mio: false),
        );
      });
      _bajar();
    });
  }

  void _llamar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Llamando a ${widget.nombre}...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _encabezado(),
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                children: [
                  _avisoAsignado(),
                  const SizedBox(height: 16),
                  for (final m in _mensajes) _burbuja(m),
                ],
              ),
            ),
            _chipsRapidos(),
            _barraEscribir(),
          ],
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      margin: const EdgeInsets.only(top: 12, right: 12),
      padding: const EdgeInsets.fromLTRB(8, 14, 20, 14),
      decoration: const BoxDecoration(
        color: _headerBg,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          InkResponse(
            onTap: () => Navigator.maybePop(context),
            radius: 24,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.chevron_left, size: 38, color: _chevron),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _avatar,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline,
                size: 28, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.nombre,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          InkResponse(
            onTap: _llamar,
            radius: 24,
            child: const Icon(Icons.phone_in_talk, size: 28, color: _teal),
          ),
        ],
      ),
    );
  }

  Widget _avisoAsignado() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFD9E8D6),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C4A3C),
            ),
            children: [
              const TextSpan(text: 'Se asignó a '),
              TextSpan(
                text: widget.nombre,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: ' a tu servicio'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _burbuja(_Msg m) {
    final TextStyle base = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: m.mio ? Colors.white : Colors.black,
    );

    final Widget contenido = m.saludo
        ? Text.rich(
            TextSpan(
              style: base,
              children: [
                const TextSpan(text: 'Hola, soy '),
                TextSpan(
                  text: widget.nombre,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const TextSpan(
                    text: ' ¿Hay algo que deba de saber antes de llegar?'),
              ],
            ),
          )
        : Text(m.texto, style: base);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Align(
        alignment: m.mio ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: m.mio ? _enviado : _recibido,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomLeft: Radius.circular(m.mio ? 24 : 4),
                bottomRight: Radius.circular(m.mio ? 4 : 24),
              ),
            ),
            child: contenido,
          ),
        ),
      ),
    );
  }

  Widget _chipsRapidos() {
    Widget chip(String label, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Material(
          color: _chip,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          chip(
            'Confirmar precio',
            () => _enviar(
              '¿Me confirmas el precio del servicio?',
              respuesta: 'Claro, el total acordado es de \$350. ¿Te parece bien?',
            ),
          ),
          chip(
            'Compartir ubicación',
            () => _enviar(
              '📍 Ubicación compartida',
              respuesta: 'Recibida, ya tengo tu ubicación',
            ),
          ),
          chip(
            'Enviar foto',
            () => _enviar(
              '📷 Foto enviada',
              respuesta: 'Gracias por la foto, la reviso',
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraEscribir() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 4, 8, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x21000000),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.attach_file, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (v) => _enviar(v),
                cursorColor: _teal,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _enviar(_controller.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: _enviarBtn,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}