import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsData {
  String? category;
  String? id;

  String? title;
  String? description;

  double? price;

  List? images;
  List? sizes;

  ProductsData.fromDocuments(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot['title'];
    description = snapshot['description'];
    price = snapshot['price'] + 0.0;
    images = snapshot['images'];
    sizes = snapshot['size'];
  }

  Map<String, dynamic> toResumeMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}
