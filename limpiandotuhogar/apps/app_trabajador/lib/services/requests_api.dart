import 'dart:async';

import 'api_client.dart';

/// Datos de la casa/oficina (tabla `galaxias`).
class HouseInput {
  const HouseInput({
    this.tipo = 'CASA', // CASA | OFICINA | DEPARTAMENTO
    required this.habitaciones,
    required this.banos,
    required this.mediosBanos,
    required this.pisos,
  });

  final String tipo;
  final int habitaciones;
  final int banos;
  final int mediosBanos;
  final int pisos;

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'habitaciones': habitaciones,
        'banos': banos,
        'medios_banos': mediosBanos,
        'pisos': pisos,
      };
}

class RemoteHouse {
  const RemoteHouse({
    required this.id,
    required this.tipo,
    required this.habitaciones,
    required this.banos,
    required this.mediosBanos,
    required this.pisos,
  });

  final int id;
  final String tipo;
  final int habitaciones;
  final int banos;
  final int mediosBanos;
  final int pisos;

  factory RemoteHouse.fromJson(Map<String, dynamic> json) => RemoteHouse(
        id: json['id'] as int,
        tipo: json['tipo'] as String,
        habitaciones: json['habitaciones'] as int,
        banos: json['banos'] as int,
        mediosBanos: json['medios_banos'] as int,
        pisos: json['pisos'] as int,
      );
}

/// Una solicitud tal como la guarda el backend (tabla `hoyo_negro`).
///
/// El campo `seleccion` (JSON libre) lo llena la app del cliente con estas
/// llaves; todas son opcionales y los getters ya traen valores por defecto:
///
///   tipoLimpieza, descripcion, servicioExtra, precioExtra, detallesExtra,
///   condiciones (lista), areas (lista), metros2, notas, direccion, zona,
///   duracionHoras, fotos (lista de URLs)
class RemoteRequest {
  const RemoteRequest({
    required this.id,
    required this.clienteId,
    required this.clienteNombre,
    this.clienteTelefono,
    required this.fecha,
    required this.total,
    required this.estado,
    this.trabajadorId,
    required this.casa,
    required this.seleccion,
  });

  final int id;
  final int clienteId;
  final String clienteNombre;
  final String? clienteTelefono;
  final DateTime fecha;
  final double total;
  final String estado; // 'DISPONIBLE' | 'ACEPTADA'
  final int? trabajadorId;
  final RemoteHouse casa;
  final Map<String, dynamic> seleccion;

  bool get disponible => estado == 'DISPONIBLE';

  factory RemoteRequest.fromJson(Map<String, dynamic> json) {
    final cliente = json['estrellas'] as Map<String, dynamic>?;
    final rawSeleccion = json['seleccion'];
    return RemoteRequest(
      id: json['id'] as int,
      clienteId: json['cliente_id'] as int,
      clienteNombre: (cliente?['name'] as String?) ?? 'Cliente',
      clienteTelefono: cliente?['phone_number'] as String?,
      fecha: json['fecha'] == null
          ? DateTime.now()
          : DateTime.parse(json['fecha'] as String).toLocal(),
      total: double.parse(json['total'].toString()), // Decimal llega como texto
      estado: json['estado'] as String,
      trabajadorId: json['trabajador_id'] as int?,
      casa: RemoteHouse.fromJson(json['galaxias'] as Map<String, dynamic>),
      seleccion: rawSeleccion is Map<String, dynamic> ? rawSeleccion : const {},
    );
  }

  // ── Getters sobre `seleccion` ─────────────────────────────────────
  String get tipoLimpieza =>
      (seleccion['tipoLimpieza'] as String?) ?? 'Limpieza general';
  String get descripcion => (seleccion['descripcion'] as String?) ?? '';
  String? get servicioExtra => seleccion['servicioExtra'] as String?;
  double get precioExtra => (seleccion['precioExtra'] as num?)?.toDouble() ?? 0;
  String get detallesExtra => (seleccion['detallesExtra'] as String?) ?? '';
  List<String> get condiciones => _strings('condiciones');
  List<String> get areas => _strings('areas');
  List<String> get fotos => _strings('fotos');
  int get metros2 => (seleccion['metros2'] as num?)?.toInt() ?? 0;
  String get notas => (seleccion['notas'] as String?) ?? '';
  String get direccion => (seleccion['direccion'] as String?) ?? '';
  String get zona => (seleccion['zona'] as String?) ?? '';
  int get duracionHoras => (seleccion['duracionHoras'] as num?)?.toInt() ?? 3;

  List<String> _strings(String key) {
    final v = seleccion[key];
    return v is List ? v.map((e) => e.toString()).toList() : const [];
  }
}

class RequestsApi {
  RequestsApi._();

  /// Lado CLIENTE: crea la casa y luego la solicitud de limpieza.
  static Future<RemoteRequest> crear({
    required int clienteId,
    required HouseInput casa,
    required DateTime fecha,
    required double total,
    required Map<String, dynamic> seleccion,
  }) async {
    final galaxia = await ApiClient.post('/galaxias', casa.toJson())
        as Map<String, dynamic>;

    final data = await ApiClient.post('/hoyo-negro', {
      'cliente_id': clienteId,
      'fecha': fecha.toUtc().toIso8601String(),
      'seleccion': seleccion,
      'total': total,
      'id_galaxias': galaxia['id'],
    });
    return RemoteRequest.fromJson(data as Map<String, dynamic>);
  }

  /// Lado TRABAJADOR: solicitudes que nadie ha tomado.
  static Future<List<RemoteRequest>> disponibles() async {
    final data =
        await ApiClient.get('/hoyo-negro/disponibles') as List<dynamic>;
    return data
        .map((e) => RemoteRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Lado TRABAJADOR: las que ya aceptó.
  static Future<List<RemoteRequest>> deTrabajador(int trabajadorId) async {
    final data = await ApiClient.get('/hoyo-negro?trabajador_id=$trabajadorId')
        as List<dynamic>;
    return data
        .map((e) => RemoteRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Lado TRABAJADOR: aceptar. Lanza ApiException (409) si ya la tomó otro.
  static Future<RemoteRequest> aceptar({
    required int id,
    required int trabajadorId,
  }) async {
    final data = await ApiClient.patch('/hoyo-negro/$id/aceptar', {
      'trabajador_id': trabajadorId,
    });
    return RemoteRequest.fromJson(data as Map<String, dynamic>);
  }

  /// Consulta las disponibles cada [every]; así la solicitud del cliente
  /// aparece en la app del trabajador a los pocos segundos.
  static Stream<List<RemoteRequest>> watchDisponibles({
    Duration every = const Duration(seconds: 3),
  }) async* {
    while (true) {
      try {
        yield await disponibles();
      } on ApiException {
        // Sin conexión un momento: se ignora y se reintenta en el siguiente ciclo.
      }
      await Future<void>.delayed(every);
    }
  }
}
