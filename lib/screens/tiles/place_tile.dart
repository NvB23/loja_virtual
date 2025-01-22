import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/image_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      surfaceTintColor: const Color.fromARGB(255, 77, 77, 78),
      shadowColor: Theme.of(context).primaryColor,
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: 100,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      snapshot: snapshot,
                    ),
                  ));
                },
                child: Image.network(
                  snapshot["image"],
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot["title"],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  snapshot["adress"],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () async {
                    String url =
                        "https://www.google.com/maps/search/?api=1&query=${snapshot["lat"]},${snapshot["lon"]}";
                    await launchUrl(Uri.parse(url));
                  },
                  child: Text(
                    "Ver no mapa",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
              TextButton(
                  onPressed: () async {
                    String url = "tel:${snapshot["phone"]}";
                    await launchUrl(Uri.parse(url));
                  },
                  child: Text(
                    "Ligar",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
