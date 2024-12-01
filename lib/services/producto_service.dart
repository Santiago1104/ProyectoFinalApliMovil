import 'package:ProyectoFinalApliMovil/models/producto.dart';

class ProductoService {
  // Aquí guardamos los productos en memoria (puedes cambiar esto para usar Firebase o SQLite).
  static final List<Producto> _productos = [];

  // Obtener todos los productos
  List<Producto> obtenerProductos() {
    return _productos;
  }

  // Agregar un nuevo producto
  void agregarProducto(Producto producto) {
    _productos.add(producto);
  }

  // Editar un producto existente
  void editarProducto(String id, Producto nuevoProducto) {
    int index = _productos.indexWhere((producto) => producto.id == id);
    if (index != -1) {
      _productos[index] = nuevoProducto;
    }
  }

  // Eliminar un producto por ID
  void eliminarProducto(String id) {
    _productos.removeWhere((producto) => producto.id == id);
  }
}
