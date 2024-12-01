import 'package:flutter/material.dart';
import 'package:ProyectoFinalApliMovil/services/producto_service.dart';
import 'add_producto_screen.dart';
import 'package:ProyectoFinalApliMovil/models/producto.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Compras')),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1), () => ProductoService().obtenerProductos()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Producto> productos = snapshot.data ?? [];

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return ListTile(
                title: Text(producto.nombre),
                subtitle: Text(producto.sitio),
                onTap: () {
                  // Navegar a la pantalla de edición con el producto seleccionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductoScreen(producto: producto),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de agregar un nuevo producto
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
