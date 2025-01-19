import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                "Erro ${snapshot.error} encontrado.",
                style: const TextStyle(color: Colors.black),
              ));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Sem dados."));
            } else {
              var dividedTiles = ListTile.divideTiles(
                      tiles: snapshot.data!.docs.map((doc) {
                        return CategoryTile(document: doc);
                      }).toList(),
                      color: Colors.black45)
                  .toList();

              return ListView(
                children: dividedTiles,
              );
            }
        }
      },
    );
  }
}
