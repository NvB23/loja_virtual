// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ExpansionTile(
        title: const Text("Cupom de desconto"),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              initialValue: CartModel.of(context).couponDescont ?? "",
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection("coupons")
                    .doc(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data() != null) {
                    CartModel.of(context).setCoupon(text, docSnap["percent"]);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Cupom ${docSnap.id} de ${docSnap["percent"]}% aplicado com sucesso."),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Erro ao aplicar o cupom de desconto."),
                      backgroundColor: Colors.red,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
