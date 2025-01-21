import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/products_data.dart';
import 'package:loja_virtual/model/cart_model.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.product, {super.key});

  final CartProduct product;

  @override
  Widget build(BuildContext context) {
    Widget buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 120,
            child: Image.network(
              product.productData!.images![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productData!.title!,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Tamanho: ${product.size}",
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Text(
                          product.productData!.price!.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).primaryColor),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: product.quantity! > 1
                                  ? () {
                                      CartModel.of(context).decProduct(product);
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(product.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                CartModel.of(context).incProduct(product);
                              },
                              icon: const Icon(Icons.add),
                              color: Theme.of(context).primaryColor,
                            ),
                            TextButton(
                                onPressed: () {
                                  CartModel.of(context).removeCartItem(product);
                                },
                                child: Text(
                                  "Remover",
                                  style: TextStyle(color: Colors.grey[500]),
                                ))
                          ],
                        ),
                      ]))),
        ],
      );
    }

    return Card(
      shadowColor: Theme.of(context).primaryColor,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(product.category)
                  .collection("items")
                  .doc(product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  product.productData =
                      ProductsData.fromDocuments(snapshot.data!);
                  return buildContent();
                } else {
                  return const SizedBox(
                    height: 70,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              })
          : buildContent(),
    );
  }
}
