import 'package:flutter/material.dart';
import 'package:ProyectoFinalApliMovil/models/producto.dart';
import 'package:ProyectoFinalApliMovil/services/producto_service.dart';

class AddProductoScreen extends StatefulWidget {
  final Producto? producto; // Si es null, estamos agregando un producto, si no, editando.
  const AddProductoScreen({super.key, this.producto});

  @override
  _AddProductoScreenState createState() => _AddProductoScreenState();
}

class _AddProductoScreenState extends State<AddProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _sitioController = TextEditingController();

  // Crear o editar el producto
  void _guardarProducto() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final sitio = _sitioController.text;

      // Si es un producto nuevo
      if (widget.producto == null) {
        final nuevoProducto = Producto(
          id: DateTime.now().toString(), // Generar un ID único
          nombre: nombre,
          sitio: sitio,
        );
        ProductoService().agregarProducto(nuevoProducto);
      } else {
        // Si estamos editando un producto existente
        final productoEditado = Producto(
          id: widget.producto!.id,
          nombre: nombre,
          sitio: sitio,
        );
        ProductoService().editarProducto(widget.producto!.id, productoEditado);
      }

      Navigator.pop(context); // Regresar a la pantalla anterior
    }
  }

  @override
  void initState() {
    super.initState();
    // Si estamos editando un producto, cargar sus datos en los controladores
    if (widget.producto != null) {
      _nombreController.text = widget.producto!.nombre;
      _sitioController.text = widget.producto!.sitio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto == null ? 'Agregar Producto' : 'Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sitioController,
                decoration: const InputDecoration(labelText: 'Sitio de Compra'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el sitio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Regresar sin guardar
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _guardarProducto,
                    child: const Text('Guardar'),
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
