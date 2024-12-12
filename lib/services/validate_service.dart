import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/Product.dart';
import '../models/ShoppingList.dart';
import '../models/Site.dart';

class validate_service {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _siteNameController = TextEditingController();

// Métodos de validación:
  String? validateListName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de la lista es obligatorio';
    }
    if (value.length < 3 || value.length > 50) {
      return 'El nombre debe tener entre 3 y 50 caracteres';
    }
    final regex = RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!regex.hasMatch(value)) {
      return 'El nombre solo puede contener letras, números y espacios';
    }
    return null;
  }

  String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre del producto es obligatorio';
    }
    if (value.length < 3 || value.length > 50) {
      return 'El nombre debe tener entre 3 y 50 caracteres';
    }
    final regex = RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!regex.hasMatch(value)) {
      return 'El nombre solo puede contener letras, números y espacios';
    }
    return null;
  }

  static String? validateSiteName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre del sitio es obligatorio';
    }
    if (value.length < 2 || value.length > 50) {
      return 'El nombre debe tener entre 2 y 50 caracteres';
    }
    final regex = RegExp(r'^[a-zA-Z0-9 ]+$');
    if (!regex.hasMatch(value)) {
      return 'Solo se permiten letras, números y espacios';
    }
    return null;
  }

  String? validateListId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debes seleccionar una lista';
    }

    // Validar que el ID tenga el formato correcto (puede ser un UUID, por ejemplo)
    final regex = RegExp(r'^[a-f0-9]{32}$'); // Suponiendo un formato de UUID
    if (!regex.hasMatch(value)) {
      return 'ID de lista inválido';
    }

    return null;
  }

  String? validateSiteId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debes seleccionar un sitio';
    }

    // Validar que el ID tenga el formato correcto
    final regex = RegExp(r'^[a-f0-9]{32}$'); // Suponiendo un formato de UUID
    if (!regex.hasMatch(value)) {
      return 'ID de sitio inválido';
    }

    return null;
  }
}