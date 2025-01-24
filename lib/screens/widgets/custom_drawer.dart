import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    UserModel userModel =
        ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    userModel.loadCurrentUser(onUserLoaded: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildDrawerBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 203, 236, 241),
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        );

    return Drawer(
      child: Stack(
        children: [
          buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(
              left: 32,
              top: 50,
            ),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 190,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Pop'z\nStore",
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.dataUser['name']}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                  child: Text(
                                    !model.isLoggedIn()
                                        ? "Entre ou cadastre-se >"
                                        : "Sair",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    if (!model.isLoggedIn()) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    } else {
                                      model.signOut();
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    }
                                  }),
                            ],
                          );
                        })),
                  ],
                ),
              ),
              const Divider(color: Colors.transparent),
              DrawerTile(
                icon: Icons.home,
                text: "Início",
                pageController: widget.pageController,
                page: 0,
              ),
              DrawerTile(
                icon: Icons.list,
                text: "Produtos",
                pageController: widget.pageController,
                page: 1,
              ),
              DrawerTile(
                icon: Icons.location_on,
                text: "Lojas",
                pageController: widget.pageController,
                page: 2,
              ),
              DrawerTile(
                icon: Icons.playlist_add_check,
                text: "Meus Pedidos",
                pageController: widget.pageController,
                page: 3,
              ),
              UserModel.of(context).firebaseUser?.email == "nmvcbs@gmail.com" &&
                      UserModel.of(context).firebaseUser != null
                  ? DrawerTile(
                      icon: Icons.add_box_rounded,
                      text: "Criar Produtos",
                      pageController: widget.pageController,
                      page: 4,
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
