import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          snapshot["title"],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Image.network(snapshot["image"]),
      ),
    );
  }
}
