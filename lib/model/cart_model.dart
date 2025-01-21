// ignore_for_file: unrelated_type_equality_checks

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
  int discountPercentage = 0;
  double freight = 65;
  bool haveCep = false;

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

  void setCoupon(String codeCoupon, int descount) {
    couponDescont = codeCoupon;
    discountPercentage = descount;
  }

  void setFreight(double freight) {
    this.freight = freight;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity! * c.productData!.price!;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return haveCep ? 0.0 : 65.0;
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double shipPrice = getShipPrice();
    double productsPrice = getProductsPrice();
    double discount = getDiscount();

    DocumentReference<Map<String, dynamic>> refOrder =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": user.firebaseUser!.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "total": productsPrice +
          (shipPrice == "Frete Grátis" ? 0 : shipPrice) -
          discount,
      "status": 1,
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({
      "orderId": refOrder.id,
    });

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    for (QueryDocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();
    couponDescont = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
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
                return CartProduct.fromDocument(doc);
                // ignore: dead_code
              }).toList());
      notifyListeners();
    }
  }
}
