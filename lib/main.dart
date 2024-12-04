import 'package:flutter/material.dart';
import '../pages/CRUDTestPage.dart';  // Asegúrate de que la página esté importada

// Importaciones de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Shopping List Tracker'),
      routes: {
        '/crud-test': (context) => CRUDTestPage(),  // Agregar la ruta para CRUDTestPage
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
                // Navegar a la lista de sitios
                Navigator.pushNamed(context, '/site-list');
              },
              child: const Text('Ir a la Lista de Sitios'),
            ),
            const SizedBox(height: 20),  // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de prueba CRUD
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
