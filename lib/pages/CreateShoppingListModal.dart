import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateShoppingListModal extends StatefulWidget {
  @override
  _CreateShoppingListModalState createState() => _CreateShoppingListModalState();
}

class _CreateShoppingListModalState extends State<CreateShoppingListModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _createNewList() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('lista_compras').add({
          'nombre': _nameController.text,
          'FechaRegistro': DateTime.now(),
        });
        Navigator.pop(context);
      } catch (e) {
        print("Error al crear la lista de compras: $e");
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Crear Nueva Lista de Compras'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Nombre de la Lista'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese un nombre';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _createNewList,
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
