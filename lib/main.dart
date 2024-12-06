import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_final/ui/screens/add_item.dart';
import 'firebase_options.dart';  // Asegúrate de que este archivo exista


import 'models/ShoppingList.dart';  // Asegúrate de importar AddItemScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Shopping List Tracker'),
      routes: {
        '/add-item': (context) => AddItemScreen( // Ruta a la pantalla de agregar producto
          shoppingList: ShoppingList(id: '1', name: 'Lista de Compras', date: DateTime.now()),
        ),
        // Agrega otras rutas si es necesario
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navegar a la Lista de Sitios (deberías tener una pantalla para ello)
                Navigator.pushNamed(context, '/site-list');
              },
              child: const Text('Ir a la Lista de Sitios'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de agregar/editar producto
                Navigator.pushNamed(context, '/add-item');
              },
              child: const Text('Ir a la Pantalla de Agregar Producto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de prueba CRUD (si la tienes)
                Navigator.pushNamed(context, '/crud-test');
              },
              child: const Text('Ir a la Página de CRUD'),
            ),
          ],
        ),
      ),
    );
  }
}
