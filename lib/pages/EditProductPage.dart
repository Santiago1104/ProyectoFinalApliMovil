import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Product.dart';
import '../models/Site.dart';
import '../services/firebase_service.dart';
import 'AddSite.dart';

class EditProductPage extends StatefulWidget {
  final String listId;
  final String productId;

  EditProductPage({required this.listId, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _productNameController;
  late String siteId;
  late String siteName;
  final _formKey = GlobalKey<FormState>();
  List<Site> availableSites = [];
  late String selectedSiteId;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    siteId = '';
    siteName = '';
    selectedSiteId = '';
    loadProductData();
    loadAvailableSites();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  Future<void> loadProductData() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('lista_compras')
          .doc(widget.listId)
          .collection('elementoslista')
          .doc(widget.productId)
          .get();

      if (productSnapshot.exists) {
        Product product = Product.fromFirestore(
          productSnapshot.data() as Map<String, dynamic>,
          widget.productId,
        );

        setState(() {
          _productNameController.text = product.name;
          siteId = product.siteId;
          selectedSiteId = siteId;
          loadSiteData(siteId);
        });
      }
    } catch (e) {
      print("Error al cargar los datos del producto: $e");
    }
  }

  Future<void> loadSiteData(String siteId) async {
    try {
      DocumentSnapshot siteSnapshot = await FirebaseFirestore.instance
          .collection('sitios')
          .doc(siteId)
          .get();

      if (siteSnapshot.exists) {
        Site site = Site.fromFirestore(
          siteSnapshot.data() as Map<String, dynamic>,
          siteId,
        );
        setState(() {
          siteName = site.name;
        });
      }
    } catch (e) {
      print("Error al cargar los datos del sitio: $e");
    }
  }

  Future<void> loadAvailableSites() async {
    try {
      QuerySnapshot siteSnapshot =
      await FirebaseFirestore.instance.collection('sitios').get();

      List<Site> sites = siteSnapshot.docs.map((doc) {
        return Site.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        availableSites = sites;
      });
    } catch (e) {
      print("Error al cargar los sitios: $e");
    }
  }

  void saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await updateProduct(
          widget.productId,
          widget.listId,
          _productNameController.text,
          selectedSiteId!,
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error al guardar los cambios: $e");
      }
    }
  }

  void cancelChanges() {
    Navigator.pop(context);
  }

  // Añadir un nuevo sitio
  void addNewSite() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddSite(
            onAdd: (String siteName) async {
              String siteId = await addSite(siteName);
              //print("Nuevo sitio añadido con ID: $siteId");
              loadAvailableSites();
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del producto';
                  }
                  return null;
                },
              ),
              // Campo para el sitio donde se va a comprar el producto
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedSiteId.isEmpty ? null : selectedSiteId,
                      decoration: InputDecoration(labelText: 'Seleccionar Sitio'),
                      items: availableSites.map((site) {
                        return DropdownMenuItem<String>(
                          value: site.id,
                          child: Text(site.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSiteId = value!;
                          siteName = availableSites.firstWhere((site) => site.id == value).name;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un sitio';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addNewSite,
                    tooltip: 'Añadir un nuevo sitio',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: saveChanges,
                    child: Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: cancelChanges,
                    child: Text('Cancelar'),
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
