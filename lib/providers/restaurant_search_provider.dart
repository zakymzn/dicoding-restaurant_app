import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:dicoding_restaurant_app/utility/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantAPI restaurantAPI;
  String query;

  RestaurantSearchProvider({
    required this.restaurantAPI,
    this.query = '',
  }) {
    _fetchAllRestaurantSearch(query);
  }

  late RestaurantSearch _restaurantSearch;
  late ResultState _state;
  String _message = '';

  RestaurantSearch get search => _restaurantSearch;
  ResultState get state => _state;
  String get message => _message;

  searchRestaurant(String newValue) {
    query = newValue;
    _fetchAllRestaurantSearch(query);
    notifyListeners();
  }

  Future _fetchAllRestaurantSearch(value) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await restaurantAPI.search(value);
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
