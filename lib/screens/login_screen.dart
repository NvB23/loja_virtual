import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:loja_virtual/screens/tabs/home_tab.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obcuredText = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Entrar na Conta",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
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
                  controller: emailController,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Email vazio";
                    } else if (!text.contains('@') || !text.contains('.com')) {
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        if (emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Preencha o campo email e pressione novamente "Esqueci minha senha".'),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          model.recovePass(emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                'Verifique a caixa de entrada do seu email.'),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: const Duration(seconds: 3),
                          ));
                        }
                      },
                      style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          overlayColor:
                              WidgetStatePropertyAll(Colors.transparent)),
                      child: const Text(
                        "Esqueci minha senha",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text;
                        String password = passwordController.text;
                        model.singIn(
                            email: email,
                            password: password,
                            onSuccess: onSuccess,
                            onFail: onFail);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text("Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20))),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Ainda não tem uma conta?",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                    },
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      minimumSize: WidgetStatePropertyAll(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "CRIAR CONTA",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
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
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    onPressed: () {
                      model.signUpsignInWithGoogle(
                          onSuccess: onSuccess, onFail: onFail);
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 2, color: Theme.of(context).primaryColor)),
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
      }),
    );
  }

  void onSuccess() {
    Navigator.of(context).pop();
  }

  void onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Erro ao logar."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
