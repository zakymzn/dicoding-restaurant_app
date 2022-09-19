import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
