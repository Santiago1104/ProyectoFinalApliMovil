import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ShoppingList.dart';
import '../models/Product.dart';
import '../models/Site.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

Future<String> createNewList(String name) async {
  try {
    DocumentReference docRef = await database.collection('lista_compras').add({
      'nombre': name,
      'FechaRegistro': DateTime.now(),
    });
    print("Lista de compras creada con ID: ${docRef.id}");
    return docRef.id;
  } catch (e) {
    print("Error al crear la lista de compras: $e");
    throw e;
  }
}



// Leer todas las listas de compras
Stream<List<ShoppingList>> readLists() {
  return database.collection('lista_compras').orderBy('FechaRegistro', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => ShoppingList.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList(),
  );
}

// Actualizar una lista de compras
Future<void> updateShoppingList(ShoppingList list) async {
  try {
    await database.collection('lista_compras').doc(list.id).update(list.toMap());
    print("Lista actualizada exitosamente.");
  } catch (e) {
    print("Error al actualizar la lista: $e");
  }
}

// Eliminar una lista de compras
Future<void> deleteShoppingList(String listId) async {
  try {
    await database.collection('lista_compras').doc(listId).delete();
    print("Lista eliminada exitosamente.");
  } catch (e) {
    print("Error al eliminar la lista: $e");
  }
}

// Crear un producto en una lista

Future<void> addProductToList(String listId, String name, String siteId) async {
  try {
    await FirebaseFirestore.instance.collection('lista_compras').doc(listId).collection('elementoslista').add({
      'nombre': name,
      'id_sitio': siteId,
      'marcado': false,
      'fecha_registro': DateTime.now(),
      'IdLista': listId,
    });
    print("Producto añadido a la lista con listId: $listId");
  } catch (e) {
    print("Error al añadir el producto: $e");
  }
}

// Leer productos de una lista
Stream<List<Product>> readProducts(String listId) {
  return database.collection('lista_compras').doc(listId).collection('elementoslista').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  });
}

// Actualizar un producto
Future<void> updateProduct(String productId, String listId, String name, String siteId) async {
  try {
    await database.collection('lista_compras').doc(listId).collection('elementoslista').doc(productId).update({
      'nombre': name,
      'id_sitio': siteId,
    });
    print("Producto actualizado.");
  } catch (e) {
    print("Error al actualizar el producto: $e");
  }
}

// Eliminar un producto
Future<void> deleteProduct(String listId, String productId) async {
  try {
    await FirebaseFirestore.instance
        .collection('lista_compras')
        .doc(listId)
        .collection('elementoslista')
        .doc(productId)
        .delete();
    print("Producto eliminado exitosamente.");
  } catch (e) {
    print("Error al eliminar el producto: $e");
  }
}


// Crear un nuevo sitio
Future<String> addSite(String name) async {
  try {
    DocumentReference docRef = await database.collection('sitios').add({
      'nombre': name,
      'fecha_registro': DateTime.now(),
    });
    print("Sitio registrado con ID: ${docRef.id}");
    return docRef.id; // Retornar el ID del documento creado
  } catch (e) {
    print("Error al registrar el sitio: $e");
    throw e;
  }
}



// Leer todos los sitios
Stream<List<Site>> readSites() {
  return database.collection('sitios')
      .orderBy('fecha_registro', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Site.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
      .toList());
}

// Actualizar un sitio
Future<void> updateSite(Site site) async {
  try {
    await database.collection('sitios').doc(site.id).update(site.toMap());
    print("Sitio actualizado.");
  } catch (e) {
    print("Error al actualizar el sitio: $e");
  }
}

// Eliminar un sitio
Future<void> deleteSite(String siteId) async {
  try {
    await database.collection('sitios').doc(siteId).delete();
    print("Sitio eliminado.");
  } catch (e) {
    print("Error al eliminar el sitio: $e");
  }
}
