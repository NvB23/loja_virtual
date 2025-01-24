// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/products_data.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/product_image.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen(this.product, {super.key});

  final ProductsData product;

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  String? seletedSize;

  _ProductScreenState(this.product);
  ProductsData product;

  @override
  Widget build(BuildContext context) {
    final Color primiryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title ?? "Nome do Produto",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          FlutterCarousel(
            options: FlutterCarouselOptions(
                aspectRatio: 1,
                showIndicator: true,
                indicatorMargin: 15,
                slideIndicator: CircularSlideIndicator(
                    slideIndicatorOptions: SlideIndicatorOptions(
                  indicatorBackgroundColor: Colors.white.withOpacity(0.5),
                  itemSpacing: 15,
                  currentIndicatorColor: primiryColor,
                ))),
            items: product.images!.map((url) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductImage(
                      images: product.images,
                    ),
                  ));
                },
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title ?? "Nome do Produto",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price!.toStringAsFixed(2).replaceFirst('.', ',')}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primiryColor),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 80,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: GridView(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.5,
                      ),
                      children: product.sizes!.map((size) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (seletedSize == size) {
                                seletedSize = null;
                              } else {
                                seletedSize = size;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: seletedSize == size ? 5 : 3,
                                color: seletedSize == size
                                    ? primiryColor
                                    : Colors.black45,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                size,
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: seletedSize != null
                        ? () {
                            final UserModel userModel = UserModel.of(context);

                            if (userModel.isLoggedIn()) {
                              final CartProduct cartProduct = CartProduct();
                              cartProduct.size = seletedSize;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;
                              cartProduct.productData = product;

                              CartModel.of(context).addCartItem(cartProduct);

                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const CartScreen();
                              }));
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const LoginScreen();
                              }));
                            }
                          }
                        : null,
                    style: ButtonStyle(
                        backgroundColor: seletedSize == null
                            ? const WidgetStatePropertyAll(Colors.black45)
                            : WidgetStatePropertyAll(primiryColor)),
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para comprar o produto",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Descrição",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  product.description ?? "Descrição do Produto",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
