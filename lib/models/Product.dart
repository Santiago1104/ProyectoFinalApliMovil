import 'package:cloud_firestore/cloud_firestore.dart';
class Product {
  final String id;
  final String name;
  final String siteId;
  final String listId;
  bool isChecked;
  final DateTime date;

  Product({
    required this.id,
    required this.name,
    required this.siteId,
    required this.listId,
    required this.isChecked,
    required this.date,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['nombre'] ?? '',
      siteId: data['id_sitio'] ?? '',
      listId: data['IdLista'] ?? '',
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
      'IdLista': listId,
      'marcado': isChecked,
      'fecha_registro': date,
    };
  }

  Future<void> toggleChecked() async {
    if (listId.isNotEmpty && id.isNotEmpty) {
      isChecked = !isChecked;
      try {
        await FirebaseFirestore.instance
            .collection('lista_compras')
            .doc(listId)
            .collection('elementoslista')
            .doc(id)
            .update({'marcado': isChecked});
        print("Estado de marcado actualizado a $isChecked");
      } catch (e) {
        print("Error al actualizar el estado de marcado: $e");
      }
    } else {
      print('Error: listId o id está vacío.');
    }
  }
}
