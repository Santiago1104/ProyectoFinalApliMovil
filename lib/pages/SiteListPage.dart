import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Site.dart';
import '../services/firebase_service.dart';


class SiteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Sitios'),
      ),
      body: StreamBuilder<List<Site>>(
        stream: readSites(), // El stream que lee los sitios
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay sitios registrados.'));
          }

          final sites = snapshot.data!;

          return ListView.builder(
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return ListTile(
                title: Text(site.name),
                subtitle: Text('Registrado: ${site.date.toLocal()}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Llamar a la función para eliminar el sitio
                    deleteSite(site.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSiteDialog(context); // Mostrar el cuadro de diálogo para agregar un nuevo sitio
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Mostrar un cuadro de diálogo para agregar un nuevo sitio
  void _showAddSiteDialog(BuildContext context) {
    TextEditingController siteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Sitio'),
          content: TextField(
            controller: siteController,
            decoration: InputDecoration(labelText: 'Nombre del sitio'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String siteName = siteController.text.trim();
                if (siteName.isNotEmpty) {
                  addSite(siteName); // Llamar a la función para agregar el sitio
                  Navigator.of(context).pop(); // Cerrar el diálogo
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}