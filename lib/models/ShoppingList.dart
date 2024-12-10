import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  final String id;
  final String name;
  final DateTime date;

  ShoppingList({
    required this.id,
    required this.name,
    required this.date,
  });

  factory ShoppingList.fromFirestore(Map<String, dynamic> data, String id) {
    return ShoppingList(
      id: id,
      name: data['nombre'] ?? '',
      date: (data['FechaRegistro'] != null)
          ? (data['FechaRegistro'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'FechaRegistro': date,
    };
  }
}
