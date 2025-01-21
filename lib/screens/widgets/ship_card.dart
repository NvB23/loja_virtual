import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final cepMask = MaskTextInputFormatter(mask: "#####-###");

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ExpansionTile(
        title: const Text("Calcular frete"),
        leading: const Icon(Icons.location_on),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: formKey,
              child: TextFormField(
                inputFormatters: [cepMask],
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Cep vazio.";
                  }
                  if (value.length != 9) {
                    return "Cep inválido";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu CEP",
                ),
                onFieldSubmitted: (cep) {
                  if (formKey.currentState!.validate()) {
                    CartModel.of(context).haveCep = true;
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
