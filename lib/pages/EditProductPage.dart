import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Product.dart';
import '../models/Site.dart';
import '../models/ShoppingList.dart';
import '../services/firebase_service.dart';

class EditProductPage extends StatefulWidget {
  final String listId;
  final String productId;

  EditProductPage({required this.listId, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late String productName;
  late String siteId;
  late String siteName;
  final _formKey = GlobalKey<FormState>();
  List<Site> availableSites = []; // Lista para almacenar sitios disponibles
  String? selectedSiteId;

  // Cargar los detalles del producto
  Future<void> loadProductData() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('lista_compras')
          .doc(widget.listId)
          .collection('elementoslista')
          .doc(widget.productId)
          .get();

      if (productSnapshot.exists) {
        Product product = Product.fromFirestore(productSnapshot.data() as Map<String, dynamic>, widget.productId);

        setState(() {
          productName = product.name;
          siteId = product.siteId;
          selectedSiteId = siteId; // Inicializar con el sitio actual
          loadSiteData(siteId);
        });
      }
    } catch (e) {
      print("Error al cargar los datos del producto: $e");
    }
  }

  // Cargar los detalles del sitio
  Future<void> loadSiteData(String siteId) async {
    try {
      DocumentSnapshot siteSnapshot = await FirebaseFirestore.instance.collection('sitios').doc(siteId).get();

      if (siteSnapshot.exists) {
        Site site = Site.fromFirestore(siteSnapshot.data() as Map<String, dynamic>, siteId);
        setState(() {
          siteName = site.name;
        });
      }
    } catch (e) {
      print("Error al cargar los datos del sitio: $e");
    }
  }

  // Cargar todos los sitios disponibles
  Future<void> loadAvailableSites() async {
    try {
      QuerySnapshot siteSnapshot = await FirebaseFirestore.instance.collection('sitios').get();

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

  @override
  void initState() {
    super.initState();
    productName = '';
    siteId = '';
    siteName = '';
    selectedSiteId = '';
    loadProductData();
    loadAvailableSites(); // Cargar sitios disponibles
  }

  // Guardar cambios
  void saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Actualizar el producto
        await updateProduct(widget.productId, widget.listId, productName, selectedSiteId!);
        Navigator.pop(context);  // Volver a la página anterior
      } catch (e) {
        print("Error al guardar los cambios: $e");
      }
    }
  }

  // Cancelar cambios
  void cancelChanges() {
    Navigator.pop(context);  // Volver a la página anterior sin guardar
  }

  // Añadir un nuevo sitio
  void addNewSite() async {
    // Puedes redirigir a una página para crear un nuevo sitio o abrir un cuadro de diálogo
    // Aquí solo mostramos un mensaje como ejemplo
    print('Añadir un nuevo sitio');
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
              // Campo para el nombre del producto
              TextFormField(
                initialValue: productName,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                onChanged: (value) {
                  setState(() {
                    productName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del producto';
                  }
                  return null;
                },
              ),

              // Campo para el sitio donde se va a comprar el producto
              DropdownButtonFormField<String>(
                value: selectedSiteId,
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

              SizedBox(height: 20),

              // Botones para guardar, cancelar y añadir sitio
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
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addNewSite,
                    tooltip: 'Añadir un nuevo sitio',
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