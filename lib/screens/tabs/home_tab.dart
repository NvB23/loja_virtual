import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget builBodyBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              // Color.fromARGB(255, 211, 118, 130),
              // Color.fromARGB(255, 253, 181, 168),
              Color.fromARGB(255, 4, 125, 141),
              Color.fromARGB(255, 161, 217, 225)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        );

    return Stack(
      children: [
        builBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Novidades",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("home")
                    .orderBy("pos")
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Text(
                                "Erro ao se conectar aos dados! \n Erro: ${snapshot.error}"),
                          ),
                        );
                      } else {
                        final documents = snapshot.data!.docs;
                        return SliverToBoxAdapter(
                          child: GridView.custom(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverQuiltedGridDelegate(
                              crossAxisCount: 2,
                              repeatPattern: QuiltedGridRepeatPattern.inverted,
                              pattern: documents.map((e) {
                                return QuiltedGridTile(e["y"], e["x"]);
                              }).toList(),
                            ),
                            childrenDelegate: SliverChildBuilderDelegate(
                              (context, index) => FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: documents[index]['image'],
                                fit: BoxFit.cover,
                              ),
                              childCount: documents.length,
                            ),
                          ),
                        );
                      }
                  }
                }),
          ],
        )
      ],
    );
  }
}
