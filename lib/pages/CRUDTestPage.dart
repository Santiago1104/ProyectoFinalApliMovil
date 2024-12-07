import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../models/ShoppingList.dart';
import '../models/site.dart';
import '../services/firebase_service.dart'; // Asegúrate de importar todos los servicios necesarios

class CRUDTestPage extends StatelessWidget {
  const CRUDTestPage({Key? key}) : super(key: key);

  Future<void> createTestData() async {
    try {
      // Crear un sitio de prueba
      final siteId = await addSite('Supermercado de Prueba');

      // Crear una lista de compras de prueba
      final shoppingListId = await createNewList('Lista de Compras de Prueba');

      // Crear productos de prueba
      await addProductToList(shoppingListId, 'Producto 1', siteId);
      await addProductToList(shoppingListId, 'Producto 2', siteId);

      print("Datos de prueba creados correctamente.");
    } catch (e) {
      print("Error al crear datos de prueba: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Test Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: createTestData,
          child: const Text('Crear Datos de Prueba'),
        ),
      ),
    );
  }
}
