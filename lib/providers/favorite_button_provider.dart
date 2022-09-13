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
