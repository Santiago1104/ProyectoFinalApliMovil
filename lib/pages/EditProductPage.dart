import 'package:flutter/material.dart';

class EditProductPage extends StatelessWidget {
  final String listId;
  final String productId;

  EditProductPage({required this.listId, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
      ),
      body: Center(
        child: Text('Página de edición de producto.'),
      ),
    );
  }
}
