import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  String? couponDescont;
  int descountPercentage = 0;

  CartModel({required this.user}) {
    initializeCart();
  }

  void initializeCart() async {
    if (user.firebaseUser == null) {
      await user.loadCurrentUser();
    }
    if (user.isLoggedIn()) {
      listenToCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    if (user.firebaseUser == null) {
      user.loadCurrentUser();
    }

    if (user.firebaseUser == null) {
      throw Exception("Usuário não está autenticado!");
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
      products.add(cartProduct);
      notifyListeners();
    }).catchError((e) {
      "Erro ao adicionar item ao carrinho! $e";
    });
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete()
        .then((_) {
      products.remove(cartProduct);
      notifyListeners();
    }).catchError((e) {
      "Erro ao remover item do carrinho! $e";
    });
  }

  void decProduct(CartProduct product) {
    product.quantity = product.quantity! - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(product.cid)
        .update(product.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct product) {
    product.quantity = product.quantity! + 1;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(product.cid)
        .update(product.toMap());
    notifyListeners();
  }

  void listenToCartItems() {
    if (user.firebaseUser == null) {
      user.loadCurrentUser();
    }

    if (user.firebaseUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.firebaseUser!.uid)
          .collection("cart")
          .snapshots()
          .listen((snapshot) => products = snapshot.docs.map((doc) {
                notifyListeners();
                return CartProduct.fromDocument(doc);
                // ignore: dead_code
              }).toList());
      notifyListeners();
    }
  }
}
