// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.pageController,
      required this.page});

  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          pageController.jumpToPage(page);
          Navigator.of(context).pop();
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: pageController.page == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              const SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    color: pageController.page == page
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
