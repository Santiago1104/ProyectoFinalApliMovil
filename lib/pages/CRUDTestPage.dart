import 'package:flutter/material.dart';
import '../services/firebase_service.dart'; // Asegúrate de importar los métodos CRUD
import '../models/Product.dart';
import '../models/ShoppingList.dart';
import '../models/Site.dart';

class CRUDTestPage extends StatefulWidget {
  @override
  _CRUDTestPageState createState() => _CRUDTestPageState();
}

class _CRUDTestPageState extends State<CRUDTestPage> {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _siteNameController = TextEditingController();

  String? selectedListId;
  String? selectedSiteId;

  @override
  void dispose() {
    _listNameController.dispose();
    _productNameController.dispose();
    _siteNameController.dispose();
    super.dispose();
  }

  // Crear nueva lista
  void _createNewList() async {
    await createNewList();
  }

  // Agregar producto a una lista
  void _addProductToList() async {
    if (selectedListId != null && selectedSiteId != null && _productNameController.text.isNotEmpty) {
      await addProductToList(selectedListId!, _productNameController.text, selectedSiteId!);
      _productNameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Producto añadido a la lista")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, complete todos los campos")));
    }
  }

  // Crear un nuevo sitio
  void _addSite() async {
    if (_siteNameController.text.isNotEmpty) {
      await addSite(_siteNameController.text);
      _siteNameController.clear();
    }
  }

  // Mostrar listas y productos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Test Page")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Crear nueva lista de compras
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Crear Lista de Compras", style: TextStyle(fontSize: 18)),
                  ElevatedButton(
                    onPressed: _createNewList,
                    child: Text("Crear Lista de Compras"),
                  ),
                ],
              ),
            ),

            // Agregar producto a una lista
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Agregar Producto a Lista", style: TextStyle(fontSize: 18)),
                  TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(labelText: "Nombre del Producto"),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: readLists(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("No hay listas disponibles");
                      }

                      return DropdownButton<String>(
                        value: selectedListId,
                        hint: Text("Seleccionar Lista"),
                        onChanged: (value) {
                          setState(() {
                            selectedListId = value;
                          });
                        },
                        items: snapshot.data!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list['id'],
                            child: Text(list['FechaRegistro']),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 10),

                  StreamBuilder<List<Site>>(
                    stream: readSites(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("No hay sitios disponibles");
                      }

                      return DropdownButton<String>(
                        value: selectedSiteId,
                        hint: Text("Seleccionar Sitio"),
                        onChanged: (value) {
                          setState(() {
                            selectedSiteId = value;
                          });
                        },
                        items: snapshot.data!.map((site) {
                          return DropdownMenuItem<String>(
                            value: site.id,
                            child: Text(site.name),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _addProductToList,
                    child: Text("Agregar Producto"),
                  ),
                ],
              ),
            ),

            // Crear nuevo sitio
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Registrar Sitio", style: TextStyle(fontSize: 18)),
                  TextField(
                    controller: _siteNameController,
                    decoration: InputDecoration(labelText: "Nombre del Sitio"),
                  ),
                  ElevatedButton(
                    onPressed: _addSite,
                    child: Text("Registrar Sitio"),
                  ),
                ],
              ),
            ),

            // Mostrar listas de compras y productos
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: readLists(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("No hay listas de compras disponibles");
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var list = snapshot.data![index];
                          return ListTile(
                            title: Text('Lista: ${list['FechaRegistro']}'),
                            subtitle: Text('ID: ${list['id']}'),
                            onTap: () {
                              setState(() {
                                selectedListId = list['id'];
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  if (selectedListId != null)
                    StreamBuilder<List<Product>>(
                      stream: readProducts(selectedListId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text("No hay productos en esta lista");
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var product = snapshot.data![index];
                            return ListTile(
                              title: Text('Producto: ${product.name}'),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}