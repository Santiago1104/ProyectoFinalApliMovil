import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Product.dart';
import '../models/ShoppingList.dart';
import '../models/Site.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

//crear una lista

Future<void> createNewList() async {
  try {
    await database.collection('lista_compras').add({
      'FechaRegistro': DateTime.now().toIso8601String(),
    });
    print("Lista de compras creada.");
  } catch (e) {
    print("Error al crear la lista de compras: $e");
  }
}

// leer todas las listas

Stream<List<Map<String, dynamic>>> readLists() {
  return database.collection('lista_compras').orderBy('FechaRegistro', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList(),
  );
}


//actualizar lista

Future<void> updateShoppingList(ShoppingList list) async {
  try {
    await database.collection('listas_compras').doc(list.id).update(list.toMap());
    print("Lista actualizada exitosamente.");
  } catch (e) {
    print("Error al actualizar la lista: $e");
  }
}

// eliminar lista

Future<void> deleteShoppingList(String listId) async {
  try {
    await database.collection('listas_compras').doc(listId).delete();
    print("Lista eliminada exitosamente.");
  } catch (e) {
    print("Error al eliminar la lista: $e");
  }
}

// crear  producto

Future<void> addProductToList(String idLista, String nombreProducto, String idSitio) async {
  try {
    await database.collection('elementoslista').add({
      'IdLista': idLista,
      'Nombre': nombreProducto,
      'IdSitio': idSitio,
    });
    print("Producto añadido a la lista.");
  } catch (e) {
    print("Error al añadir el producto: $e");
  }
}


// leer productos de lista

Stream<List<Product>> readProducts(String listId) {
  return database.collection('listas_compras').doc(listId).collection('elementos').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  });
}

//actualizar productos de lista

Future<void> updateProduct(String idProducto, String nuevoNombre, String nuevoIdSitio) async {
  try {
    await database.collection('elementoslista').doc(idProducto).update({
      'Nombre': nuevoNombre,
      'IdSitio': nuevoIdSitio,
    });
    print("Producto actualizado.");
  } catch (e) {
    print("Error al actualizar el producto: $e");
  }
}


//eliminar productos

Future<void> deleteProduct(String idProducto) async {
  try {
    await database.collection('elementoslista').doc(idProducto).delete();
    print("Producto eliminado.");
  } catch (e) {
    print("Error al eliminar el producto: $e");
  }
}


// Crear un sitio

Future<void> addSite(String nombreSitio) async {
  try {
    Site newSite = Site(
      id: '',
      name: nombreSitio,
      date: DateTime.now(),
    );

    await database.collection('sitios').add(newSite.toMap());

    print("Sitio registrado.");
  } catch (e) {
    print("Error al registrar el sitio: $e");
  }
}

// Leer todos los sitios
Stream<List<Site>> readSites() {
  return database.collection('sitios')
      .orderBy('fecha_registro', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Site.fromFirestore(doc.data(), doc.id))
      .toList());
}
// Actualizar un sitio
Future<void> updateSite(Site site) async {
  try {
    // Usar el ID del sitio para encontrar el documento y actualizarlo
    await database.collection('sitios').doc(site.id).update(site.toMap());
    print("Sitio actualizado.");
  } catch (e) {
    print("Error al actualizar el sitio: $e");
  }
}

// Eliminar un sitio
Future<void> deleteSite(String siteId) async {
  try {
    // Usar el ID del sitio para eliminar el documento de Firestore
    await database.collection('sitios').doc(siteId).delete();
    print("Sitio eliminado.");
  } catch (e) {
    print("Error al eliminar el sitio: $e");
  }
}










