import 'package:dicoding_restaurant_app/providers/favorite_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFavorited = Provider.of<FavoriteButtonProvider>(context).isFavorited;
    return IconButton(
      onPressed: () {
        if (isFavorited == false) {
          return Provider.of<FavoriteButtonProvider>(context, listen: false)
              .changeFavoriteButton(true);
        } else {
          return Provider.of<FavoriteButtonProvider>(context, listen: false)
              .changeFavoriteButton(false);
        }
      },
      icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
    );
  }
}
