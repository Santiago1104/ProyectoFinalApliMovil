import 'package:flutter/material.dart';
import 'package:proyecto_final/models/Product.dart';
import 'package:proyecto_final/models/ShoppingList.dart';
import 'package:proyecto_final/models/Site.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  final Product? product;

  AddItemScreen({required this.shoppingList, this.product});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  String _selectedSiteId = '';
  bool _isChecked = false;

  final _formKey = GlobalKey<FormState>();

  List<Site> _sites = [];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _selectedSiteId = widget.product!.siteId;
      _isChecked = widget.product!.isChecked;
    }
    _loadSites();
  }

  _loadSites() async {
    final snapshot = await FirebaseFirestore.instance.collection('sites').get();
    setState(() {
      _sites = snapshot.docs
          .map((doc) => Site.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? FirebaseFirestore.instance.collection('products').doc().id,
        name: _nameController.text,
        siteId: _selectedSiteId,
        isChecked: _isChecked,
        date: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(product.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Agregar Producto' : 'Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedSiteId.isEmpty ? null : _selectedSiteId,
                hint: Text('Selecciona el sitio'),
                items: _sites
                    .map((site) => DropdownMenuItem<String>(
                  value: site.id,
                  child: Text(site.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSiteId = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona un sitio';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('Marcado como comprado'),
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text(widget.product == null ? 'Guardar' : 'Actualizar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
