import 'package:flutter/material.dart';
import '../models/Site.dart';
import '../services/firebase_service.dart';
import 'AddSite.dart';
import '../services/validate_service.dart';

class ManageSitesPage extends StatefulWidget {
  @override
  _ManageSitesPageState createState() => _ManageSitesPageState();
}

class _ManageSitesPageState extends State<ManageSitesPage> {
  final TextEditingController _siteNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sitios"),
      ),
      body: StreamBuilder<List<Site>>(
        stream: readSites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final sites = snapshot.data!;
          return ListView.builder(
            itemCount: sites.length,
            itemBuilder: (context, index) {
              Site site = sites[index];
              return ListTile(
                title: Text(site.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditSiteDialog(site),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteSite(site.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF9c8def),
        child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
              AddSite(
                onAdd: (siteName) {
                  addSite(
                      siteName);
                },
              ),
            );
          },
      ),
    );
  }

  void _showEditSiteDialog(Site site) {
    _siteNameController.text = site.name;  // Precarga el nombre actual del sitio en el controlador
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Sitio'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _siteNameController,
              decoration: InputDecoration(hintText: "Nombre del sitio"),
              validator: validate_service.validateSiteName,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                _siteNameController.clear();
              },
            ),
            TextButton(
              child: Text('Actualizar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Site updatedSite = Site(
                      id: site.id,
                      name: _siteNameController.text,
                      date: site.date  // Mantiene la fecha original de registro
                  );
                  updateSite(updatedSite);
                  Navigator.of(context).pop();
                  _siteNameController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSite(String siteId) {
    deleteSite(siteId);
  }
}
