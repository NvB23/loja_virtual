import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.images});

  final List<dynamic>? images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: PageView(
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          children: images!.map((img) {
            return Image.network(img);
          }).toList(),
        ),
      ),
    );
  }
}
