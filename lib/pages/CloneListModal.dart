import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ShoppingList.dart';

class CloneListModal extends StatefulWidget {
  final ShoppingList shoppingList;

  const CloneListModal({Key? key, required this.shoppingList}) : super(key: key);

  @override
  State<CloneListModal> createState() => _CloneListModalState();
}
class _CloneListModalState extends State<CloneListModal> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> clonedProducts = [];  // Lista para almacenar los productos clonados

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Copia de ${widget.shoppingList.name}';
  }

  Future<void> _cloneList(String newName) async {
    try {
      // Obtener los productos de la lista original
      final productSnapshot = await FirebaseFirestore.instance
          .collection('lista_compras')
          .doc(widget.shoppingList.id)
          .collection('elementoslista')
          .get();

      // Crear la nueva lista clonada
      final newListDoc = await FirebaseFirestore.instance
          .collection('lista_compras')
          .add({
        'nombre': newName,
        'FechaRegistro': DateTime.now(),
      });

      // Clonar los productos en la nueva lista y agregar a la lista de productos clonados
      List<Map<String, dynamic>> productsList = [];
      for (var productDoc in productSnapshot.docs) {
        var productData = productDoc.data();
        productsList.add({
          'id': productDoc.id,
          'nombre': productData['nombre'],
          'id_sitio': productData['id_sitio'],
          'marcado': productData['marcado'] ?? false,  // Estado de marcado
        });

        // Clonar el producto en la nueva lista
        await FirebaseFirestore.instance
            .collection('lista_compras')
            .doc(newListDoc.id)
            .collection('elementoslista')
            .add({
          'nombre': productData['nombre'],
          'id_sitio': productData['id_sitio'],
          'IdLista': newListDoc.id,
          'marcado': productData['marcado'] ?? false,  // Estado de marcado
          'fecha_registro': productData['fecha_registro'],
        });
      }

      // Actualizar el estado de los productos clonados
      setState(() {
        clonedProducts = productsList;  // Guardar los productos clonados
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lista "$newName" clonada correctamente.'),
          backgroundColor: Colors.green,
        ),
      );

      // Cerrar el modal
      Navigator.pop(context);
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al clonar la lista: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Método para actualizar el estado de marcado de un producto en Firestore
  Future<void> _updateProductChecked(String productId, bool isChecked) async {
    try {
      await FirebaseFirestore.instance
          .collection('lista_compras')
          .doc(widget.shoppingList.id)
          .collection('elementoslista')
          .doc(productId)
          .update({'marcado': isChecked});

      setState(() {
        // Actualizar el estado localmente en la lista clonada
        clonedProducts.firstWhere((product) => product['id'] == productId)['marcado'] = isChecked;
      });
    } catch (e) {
      print("Error al actualizar el estado de marcado: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clonar Lista: ${widget.shoppingList.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nuevo nombre de la lista'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: clonedProducts.length,
                  itemBuilder: (context, index) {
                    var product = clonedProducts[index];
                    return ListTile(
                      title: Text(product['nombre']),
                      trailing: Checkbox(
                        value: product['marcado'],
                        onChanged: (bool? value) {
                          _updateProductChecked(product['id'], value ?? false);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cloneList(_nameController.text.trim());
                      }
                    },
                    child: const Text('Clonar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
