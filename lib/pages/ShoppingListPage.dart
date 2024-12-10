import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ShoppingList.dart';
import '../models/Product.dart';
import '../models/Site.dart';
import 'EditProductPage.dart';
import 'CreateProductPage.dart';
import 'CreateShoppingListModal.dart';
import '../services/firebase_service.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  Stream<List<ShoppingList>> readLists() {
    return FirebaseFirestore.instance
        .collection('lista_compras')
        .orderBy('FechaRegistro', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingList.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Stream<List<Product>> readProducts(String listId) {
    return FirebaseFirestore.instance
        .collection('lista_compras')
        .doc(listId)
        .collection('elementoslista')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<Site?> getSiteDetails(String siteId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('sitios')
          .doc(siteId)
          .get();

      if (doc.exists) {
        return Site.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Error al obtener detalles del sitio: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas de Compras'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CreateShoppingListModal(),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ShoppingList>>(
        stream: readLists(),
        builder: (context, listSnapshot) {
          if (listSnapshot.hasError) {
            return Center(child: Text('Error: ${listSnapshot.error}'));
          } else if (listSnapshot.hasData) {
            final lists = listSnapshot.data!;
            if (lists.isEmpty) {
              return Center(child: Text('No hay listas de compras disponibles.'));
            }
            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final shoppingList = lists[index];
                return Dismissible(
                  key: ValueKey(shoppingList.id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    await deleteShoppingList(shoppingList.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lista eliminada')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      shoppingList.name,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Text('Fecha: ${shoppingList.date}'),
                    children: [
                      StreamBuilder<List<Product>>(
                        stream: readProducts(shoppingList.id),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.hasError) {
                            return Center(child: Text('Error: ${productSnapshot.error}'));
                          } else if (productSnapshot.hasData) {
                            final products = productSnapshot.data!;
                            if (products.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('No hay productos en esta lista.'),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return FutureBuilder<Site?>(
                                  future: getSiteDetails(product.siteId),
                                  builder: (context, siteSnapshot) {
                                    if (siteSnapshot.hasError) {
                                      return ListTile(
                                        title: Text(product.name),
                                        subtitle: Text('Error al cargar el sitio'),
                                      );
                                    } else if (siteSnapshot.hasData) {
                                      final site = siteSnapshot.data!;
                                      return Dismissible(
                                        key: ValueKey(product.id),
                                        confirmDismiss: (direction) async {
                                          if (!product.isChecked) {
                                            return true;
                                          }
                                          return false;
                                        },
                                        onDismissed: (direction) {
                                          if (!product.isChecked) {
                                            deleteProduct(shoppingList.id, product.id);
                                          }
                                        },
                                        background: Container(
                                          color: Colors.red,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 16.0),
                                              child: Icon(Icons.delete, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(product.name),
                                          subtitle: Text('Lugar: ${site.name}'),
                                          trailing: Checkbox(
                                            value: product.isChecked,
                                            onChanged: (value) async {
                                              await product.toggleChecked();
                                              setState(() {});
                                            },
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditProductPage(
                                                  listId: shoppingList.id,
                                                  productId: product.id,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  },
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateProductPage(
                                  listId: shoppingList.id,
                                ),
                              ),
                            );
                          },
                          child: Text('Añadir Producto'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
