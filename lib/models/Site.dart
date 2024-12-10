import 'package:cloud_firestore/cloud_firestore.dart';

class Site {
  final String id;
  final String name;
  final DateTime date;

  Site({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Site.fromFirestore(Map<String, dynamic> data, String id) {
    return Site(
      id: id,
      name: data['nombre'] ?? '',
      date: (data['fecha_registro'] != null)
          ? (data['fecha_registro'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'fecha_registro': date,
    };
  }
}
