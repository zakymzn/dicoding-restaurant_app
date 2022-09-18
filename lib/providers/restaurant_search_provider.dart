import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  String query;

  RestaurantSearchProvider({
    this.query = '',
  });

  searchRestaurant(String newValue) {
    query = newValue;
    notifyListeners();
  }
}
