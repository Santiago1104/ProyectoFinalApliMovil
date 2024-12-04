import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  final String id; // Identificador único
  final String name; // Nombre de la lista
  final DateTime date; // Fecha de creación

  ShoppingList({
    required this.id,
    required this.name,
    required this.date,
  });

  // Convertir un documento Firestore a una instancia de ShoppingList
  factory ShoppingList.fromFirestore(Map<String, dynamic> data, String id) {
    return ShoppingList(
      id: id,
      name: data['nombre'] ?? '',
      date: (data['fecha_registro'] as Timestamp).toDate(), // snake_case para fecha_registro
    );
  }

  // Convertir una instancia de ShoppingList a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'fecha_registro': date, // snake_case para fecha_registro
    };
  }
}
