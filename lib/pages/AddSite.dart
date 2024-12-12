import 'package:flutter/material.dart';
import '../services/validate_service.dart';


class AddSite extends StatefulWidget {
  final Function(String) onAdd;

  AddSite({required this.onAdd});

  @override
  _AddSiteState createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
  final TextEditingController siteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  void _tryAddSite() {
    // Retorna true si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      widget.onAdd(siteController.text);  // Use the callback function
      Navigator.of(context).pop();  // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Añadir nuevo sitio"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: siteController,
          decoration: InputDecoration(hintText: "Nombre del sitio"),
          validator: validate_service.validateSiteName,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancelar"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("Añadir"),
          onPressed: _tryAddSite,  // Usa el nuevo método que valida el formulario
        ),
      ],
    );
  }
}
