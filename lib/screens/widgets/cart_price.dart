import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  const CartPrice({super.key, required this.buy});

  final VoidCallback buy;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
        return Column(
          children: [
            Card(
              shadowColor: Theme.of(context).primaryColor,
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                    double price = model.getProductsPrice();
                    double discount = model.getDiscount();
                    double ship = model.getShipPrice();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Resumo do pedido",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Subtotal"),
                            Text("R\$ ${price.toStringAsFixed(2)}"),
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Desconto"),
                            Text("R\$ ${discount.toStringAsFixed(2)}"),
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Entrega"),
                            Text(
                              model.haveCep
                                  ? ship == 0
                                      ? "Frete Grátis"
                                      : ship.toStringAsFixed(2)
                                  : "",
                              style: TextStyle(
                                color: ship == 0 ? Colors.green : null,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            Text(
                              "R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                onPressed: () {
                  if (!model.haveCep) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Cep vazio ou inválido.",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    buy();
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                ),
                child: const Text(
                  "Finalizar Pedido",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
