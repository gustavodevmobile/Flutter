import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';

class IconFavorito extends StatelessWidget {
  const IconFavorito({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Themes.redSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border, color: Themes.white),
        ),
      ),
    );
  }
}
