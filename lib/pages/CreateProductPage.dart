import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  List<Site> availableSites = []; // Lista de sitios disponibles

  @override
  void initState() {
    super.initState();
    productName = '';
    selectedSiteId = '';
    loadAvailableSites();
  }

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

  void saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('lista_compras')
            .doc(widget.listId)
            .collection('elementoslista')
            .add({
          'nombre': productName,
          'id_sitio': selectedSiteId,
          'fecha_registro': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto guardado exitosamente')),
        );
        Navigator.pop(context); // Volver a la página anterior
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo guardar el producto. Inténtalo de nuevo.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    }
  }

  void addNewSite() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddSite(
          onAdd: (String siteName) async {
            String siteId = await addSite(siteName);
            loadAvailableSites();
            setState(() {
              selectedSiteId = siteId;
            });
          },
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
              SizedBox(height: 20),
              availableSites.isEmpty
                  ? Text('No hay sitios disponibles. Añade uno nuevo.')
                  : DropdownButtonFormField<String>(
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
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione un sitio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Container()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addNewSite,
                    tooltip: 'Añadir un nuevo sitio',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: saveProduct,
                    child: Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
