import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CartScreen();
              }));
            },
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            )),
        ScopedModelDescendant<CartModel>(builder: (context, child, model) {
          if (model.products.isEmpty) {
            return const SizedBox();
          }
          return Positioned(
            top: 5,
            right: 5,
            child: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Text(
                CartModel.of(context).products.length.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        })
      ],
    );
  }
}
