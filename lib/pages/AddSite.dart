import 'package:flutter/material.dart';

class AddSite extends StatelessWidget {
  final Function(String) onAdd; // Callback function to handle the addition

  AddSite({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    TextEditingController siteController = TextEditingController();

    return AlertDialog(
      title: Text("Añadir nuevo sitio"),
      content: TextField(
        controller: siteController,
        decoration: InputDecoration(hintText: "Nombre del sitio"),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancelar"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("Añadir"),
          onPressed: () {
            if (siteController.text.isNotEmpty) {
              onAdd(siteController.text); // Use the callback function
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
