import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OrderScreen extends StatelessWidget {
  OrderScreen({super.key, required this.orderId});

  String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "Pedido Confirmado",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 5)),
              child: Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              "Pedido ralizado com sucesso!",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
            ),
            Text(
              "Código do Pedido: $orderId",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
