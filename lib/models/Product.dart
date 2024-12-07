import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String siteId;
  bool isChecked;
  final DateTime date;

  Product({
    required this.id,
    required this.name,
    required this.siteId,
    required this.isChecked,
    required this.date,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['nombre'] ?? '',
      siteId: data['id_sitio'] ?? '',
      isChecked: data['marcado'] ?? false,
      date: (data['fecha_registro'] != null)
          ? (data['fecha_registro'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'id_sitio': siteId,
      'marcado': isChecked,
      'fecha_registro': date,
    };
  }

  Future<void> toggleChecked() async {
    isChecked = !isChecked;
    await FirebaseFirestore.instance
        .collection('elementoslista')
        .doc(id)
        .update({'marcado': isChecked});
  }
}
