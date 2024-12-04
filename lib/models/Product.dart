import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id; // Identificador único del producto
  final String name; // Nombre del producto
  final String siteId; // ID del sitio donde se compra
  final bool isChecked; // Si el producto está marcado como comprado
  final DateTime date; // Fecha de creación

  Product({
    required this.id,
    required this.name,
    required this.siteId,
    required this.isChecked,
    required this.date,
  });

  // Convertir un documento Firestore a una instancia de Product
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['nombre'] ?? '',
      siteId: data['id_sitio'] ?? '', // snake_case para id_sitio
      isChecked: data['marcado'] ?? false,
      date: (data['fecha_registro'] as Timestamp).toDate(), // snake_case para fecha_registro
    );
  }

  // Convertir una instancia de Product a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'id_sitio': siteId, // snake_case para id_sitio
      'marcado': isChecked,
      'fecha_registro': date, // snake_case para fecha_registro
    };
  }
}
