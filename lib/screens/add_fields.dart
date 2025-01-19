import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';

class AddFields extends StatefulWidget {
  const AddFields({super.key});

  @override
  State<AddFields> createState() => _AddFieldsState();
}

class _AddFieldsState extends State<AddFields> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phoneMak = MaskTextInputFormatter(
        mask: '(##) 9#### - ####', filter: {"#": RegExp(r"[0-9]")});

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Campos Adicionais",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: [
                  TextFormField(
                    controller: adressController,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Endereço vazio";
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Endereço",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: phoneController,
                    inputFormatters: [phoneMak],
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Telefone vazio";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Telefone",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                      onPressed: () {
                        Map<String, dynamic> dataUser = {
                          "adress": adressController.text,
                          "phone": phoneController.text,
                        };

                        model.signUpsignInWithGoogle(
                            dataUser: dataUser,
                            onSuccess: onSuccess,
                            onFail: onFail);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      child: const Text("Criar Conta",
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                  const SizedBox(
                    height: 30,
                  ),
                ]),
              ));
        }));
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Usuário criado com sucesso."),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 3),
    ));
    Future.delayed(const Duration(seconds: 2)).then((_) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    });
  }

  void onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Erro ao criar usuário."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
