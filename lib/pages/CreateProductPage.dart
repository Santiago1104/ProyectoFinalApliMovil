import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Site.dart';
import '../services/firebase_service.dart';
import './AddSite.dart';

class CreateProductPage extends StatefulWidget {
  final String listId;

  CreateProductPage({required this.listId});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  late String productName;
  late String selectedSiteId;
  late String siteName;
  final _formKey = GlobalKey<FormState>();
  List<Site> availableSites = []; // Lista para almacenar sitios disponibles

  @override
  void initState() {
    super.initState();
    productName = '';
    selectedSiteId = '';
    siteName = '';
    loadAvailableSites(); // Cargar sitios disponibles
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

      print("Sitios cargados:");
      sites.forEach((site) {
        print("ID: ${site.id}, Name: ${site.name}, Date: ${site.date}");
      });
    } catch (e) {
      print("Error al cargar los sitios: $e");
    }
  }

  // Guardar el nuevo producto
  void saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Agregar el producto en Firestore
        await FirebaseFirestore.instance.collection('lista_compras')
            .doc(widget.listId)
            .collection('elementoslista')
            .add({
          'name': productName,
          'siteId': selectedSiteId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context);  // Volver a la página anterior
      } catch (e) {
        print("Error al guardar el producto: $e");
      }
    }
  }

  // Cancelar y regresar
  void cancelCreation() {
    Navigator.pop(context);  // Volver a la página anterior sin guardar
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
        title: Text('Crear Producto'),
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

                // Botones para guardar, cancelar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: saveProduct,
                      child: Text('Guardar'),
                    ),
                    ElevatedButton(
                      onPressed: cancelCreation,
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
