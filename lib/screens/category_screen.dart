import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/products_data.dart';
import 'package:loja_virtual/screens/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.cartegorySnapashot});

  final DocumentSnapshot cartegorySnapashot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              cartegorySnapashot["title"],
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.grid_on,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(cartegorySnapashot.id)
                  .collection("items")
                  .get(),
              builder: (context, cartegorySnapashot) {
                if (!cartegorySnapashot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else {
                  return TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.all(4),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 0.64),
                          itemCount: cartegorySnapashot.data!.docs.length,
                          itemBuilder: (context, index) {
                            ProductsData data = ProductsData.fromDocuments(
                                cartegorySnapashot.data!.docs[index]);
                            data.category = this.cartegorySnapashot.id;
                            return ProductTile('grid', data);
                          },
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: cartegorySnapashot.data!.docs.length,
                          itemBuilder: (context, index) {
                            ProductsData data = ProductsData.fromDocuments(
                                cartegorySnapashot.data!.docs[index]);
                            data.category = this.cartegorySnapashot.id;
                            return ProductTile('list', data);
                          },
                        ),
                      ]);
                }
              }),
        ));
  }
}
