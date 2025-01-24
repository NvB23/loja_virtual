import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/add_fields.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool obcuredText = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phoneMask = MaskTextInputFormatter(
        mask: '(##) 9#### - ####', filter: {"#": RegExp(r"[0-9]")});

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Criar Conta",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: [
                  TextFormField(
                    controller: nameController,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Nome vazio";
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Nome Completo",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
                    inputFormatters: [phoneMask],
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
                  TextFormField(
                    controller: emailController,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Email vazio";
                      } else if (!text.contains('@') ||
                          !text.contains('.com')) {
                        return "Email inválio";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Senha vazia";
                      } else if (text.length < 8) {
                        return "A senha precia ter pelo menos 8 caracteres";
                      }
                      return null;
                    },
                    obscureText: obcuredText,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "Senha",
                      errorStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                        icon: obcuredText == true
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obcuredText = !obcuredText;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> dataUser = {
                            "name": nameController.text,
                            "adress": adressController.text,
                            "phone": phoneController.text,
                            "email": emailController.text,
                          };

                          model.singUp(
                            dataUser: dataUser,
                            pass: passwordController.text,
                            onSuccess: onSuccess,
                            onFail: onFail,
                            onFailEmail: onFailEmail,
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      child: const Text("Criar",
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Já tem uma conta?",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      style: const ButtonStyle(
                        overlayColor:
                            WidgetStatePropertyAll(Colors.transparent),
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        minimumSize: WidgetStatePropertyAll(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "ENTRAR NA SUA CONTA",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                      )),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Ou",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 143.0),
                    child: TextButton(
                      style: const ButtonStyle(
                        overlayColor:
                            WidgetStatePropertyAll(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddFields()));
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor)),
                        child: Image.asset(
                          "lib/assets/google_logo.png",
                          fit: BoxFit.contain,
                          height: 55,
                        ),
                      ),
                    ),
                  )
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

  void onFailEmail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Email já cadastrado."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
