import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.document});

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(document['icon']),
        ),
        title: Text(document['title']),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoryScreen(
                    snapshot: document,
                  )));
        },
      ),
    );
  }
}
