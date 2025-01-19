import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/firebase_options.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ScopedModel<CartModel>(
              model: CartModel(user: UserModel()),
              child: Builder(builder: (context) {
                return MaterialApp(
                  title: "Pop'z Store",
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    appBarTheme: const AppBarTheme(
                        iconTheme: IconThemeData(color: Colors.white)),
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color.fromARGB(255, 4, 125, 141),
                      primary: const Color.fromARGB(255, 4, 125, 141),
                    ),
                    useMaterial3: true,
                  ),
                  home: HomeScreen(),
                );
              }),
            );
          },
        ));
  }
}
