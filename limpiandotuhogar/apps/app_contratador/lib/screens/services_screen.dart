import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _Service {
  const _Service({
    required this.title,
    required this.description,
    required this.price,
    required this.basePrice,
    required this.image,
  });

  final String title;
  final String description;
  final String price;
  final int basePrice;
  final String image;
}

class _ServicesScreenState extends State<ServicesScreen> {
  int selectedIndex = 1;

  static const Color navy = Color(0xFF2E4054); // títulos y precios
  static const Color teal = Color(0xFF46707E);
  static const Color cardGreen = Color(0xFFDDEBDA); // tarjetas de servicios

  static const List<_Service> services = [
    _Service(
      title: 'Limpieza regular',
      description:
          'Limpieza de mantenimiento que incluye barrer, trapear y aspirar.',
      price: 'Desde \$400',
      basePrice: 400,
      image:
          'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=500',
    ),
    _Service(
      title: 'Limpieza profunda',
      description:
          'Limpieza detallada de todas las áreas del espacio, incluyendo zonas de difícil acceso.',
      price: 'Desde \$600',
      basePrice: 600,
      image:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=500',
    ),
    _Service(
      title: 'Limpieza post-obra',
      description: 'Limpieza después de una remodelación o construcción.',
      price: 'Desde \$650',
      basePrice: 650,
      image: 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=500',
    ),
  ];

  void _abrirServicio(_Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceDetailsScreen(
          serviceTitle: service.title,
          price: service.price,
          image: service.image,
          basePrice: service.basePrice,
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // TÍTULO
                      const Text(
                        'Servicios',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Elige el tipo de limpieza que necesitas.',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF555555),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // TARJETAS DE SERVICIOS
                      for (final service in services) ...[
                        serviceCard(service),
                        const SizedBox(height: 22),
                      ],

                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),

            AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  //SERVICIO
  Widget serviceCard(_Service service) {
    return GestureDetector(
      onTap: () => _abrirServicio(service),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: cardGreen,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto a la izquierda, difuminada hacia el borde derecho
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(22),
              ),
              child: SizedBox(
                width: 84,
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.black, Colors.transparent],
                      stops: [0.0, 0.7, 1.0],
                    ).createShader(rect);
                  },
                  child: Image.network(
                    service.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: teal,
                        child: Icon(
                          Icons.cleaning_services,
                          color: Colors.white,
                          size: 28,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Textos
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      service.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF444444),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.price,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Flecha
            const SizedBox(
              width: 34,
              child: Center(
                child: Icon(Icons.chevron_right, size: 22, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}