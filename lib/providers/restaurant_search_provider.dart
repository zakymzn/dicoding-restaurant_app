import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantAPI restaurantAPI;
  String query;

  RestaurantSearchProvider({
    required this.restaurantAPI,
    required this.query,
  }) {
    _fetchAllRestaurantSearch(query);
  }

  searchRestaurant(String newValue) {
    query = newValue;
  }

  late RestaurantSearch _restaurantSearch;
  late ResultState _state;
  String _message = '';

  RestaurantSearch get search => _restaurantSearch;
  ResultState get state => _state;
  String get message => _message;

  Future _fetchAllRestaurantSearch(query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await restaurantAPI.search(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Tidak ada data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantSearch = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error => $e';
    }
  }
}
