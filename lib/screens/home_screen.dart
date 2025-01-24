import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/create_products.dart';
import 'package:loja_virtual/screens/tabs/home_tab.dart';
import 'package:loja_virtual/screens/tabs/orders_tab.dart';
import 'package:loja_virtual/screens/tabs/places_tab.dart';
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
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Lojas",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: const PlacesTab(),
          drawer: CustomDrawer(
            pageController: pageController,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Meus Pedidos",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: const OrdersTab(),
          drawer: CustomDrawer(
            pageController: pageController,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Criar Produtos",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: const CreateProducts(),
          drawer: CustomDrawer(
            pageController: pageController,
          ),
        ),
      ],
    );
  }
}
