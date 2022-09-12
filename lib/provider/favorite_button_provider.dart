import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButtonProvider extends ChangeNotifier {
  bool isFavorited;

  FavoriteButtonProvider({
    this.isFavorited = false,
  });

  void changeFavoriteButton(bool newValue) {
    isFavorited = newValue;
    notifyListeners();
  }
}

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
