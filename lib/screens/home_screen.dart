import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/tabs/home_tab.dart';
import 'package:loja_virtual/screens/tabs/products_tab.dart';
import 'package:loja_virtual/screens/widgets/cart_button.dart';
import 'package:loja_virtual/screens/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      children: <Widget>[
        Scaffold(
          floatingActionButton: const CartButton(),
          body: const HomeTab(),
          drawer: CustomDrawer(
            pageController: pageController,
          ),
        ),
        Scaffold(
          floatingActionButton: const CartButton(),
          appBar: AppBar(
            title: const Text(
              "Produtos",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: CustomDrawer(pageController: pageController),
          body: const ProductsTab(),
        ),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.green,
        ),
      ],
    );
  }
}
