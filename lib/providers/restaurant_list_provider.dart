import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantAPI restaurantAPI;

  RestaurantListProvider({required this.restaurantAPI}) {
    _fetchAllRestaurantList();
  }

  late RestaurantList _restaurantList;
  late ResultState _state;
  String _message = '';

  RestaurantList get list => _restaurantList;
  ResultState get state => _state;
  String get message => _message;

  Future _fetchAllRestaurantList() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await restaurantAPI.list();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Tidak ada data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantList = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error => $e';
    }
  }
}
