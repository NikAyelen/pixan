import 'package:flutter/material.dart';

/// Datos de la solicitud que se van juntando a lo largo del flujo:
/// Servicios → Datos del inmueble → Áreas/extras → Horario → Colaborador → Cotización.
class ServiceRequestData {
  const ServiceRequestData({
    required this.serviceTitle,
    required this.areas,
    required this.extras,
    required this.notes,
    required this.priceMin,
    required this.priceMax,
    this.date,
    this.time,
    this.collaborator,
  });

  final String serviceTitle;
  final List<String> areas;
  final List<String> extras;
  final String notes;
  final int priceMin;
  final int priceMax;
  final DateTime? date;
  final TimeOfDay? time;
  final String? collaborator; // solo si lo eligió personalmente

  ServiceRequestData copyWith({
    DateTime? date,
    TimeOfDay? time,
    String? collaborator,
  }) {
    return ServiceRequestData(
      serviceTitle: serviceTitle,
      areas: areas,
      extras: extras,
      notes: notes,
      priceMin: priceMin,
      priceMax: priceMax,
      date: date ?? this.date,
      time: time ?? this.time,
      collaborator: collaborator ?? this.collaborator,
    );
  }

  /// dd/mm/aa
  String get dateText {
    final d = date;
    if (d == null) return '-';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = (d.year % 100).toString().padLeft(2, '0');
    return '$dd/$mm/$yy';
  }

  /// 10:00 am
  String get timeText {
    final t = time;
    if (t == null) return '-';
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final periodo = t.period == DayPeriod.am ? 'am' : 'pm';
    return '$h:$m $periodo';
  }
}