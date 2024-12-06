import 'package:cloud_firestore/cloud_firestore.dart';

class Site {
  final String id; // Identificador único del sitio
  late final String name; // Nombre del sitio
  final DateTime date; // Fecha de creación

  Site({
    required this.id,
    required this.name,
    required this.date,
  });

  // Convertir un documento Firestore a una instancia de Site
  factory Site.fromFirestore(Map<String, dynamic> data, String id) {
    return Site(
      id: id,
      name: data['nombre'] ?? '',
      date: (data['fecha_registro'] as Timestamp).toDate(), // snake_case para fecha_registro
    );
  }

  // Convertir una instancia de Site a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'fecha_registro': date, // snake_case para fecha_registro
    };
  }
}
