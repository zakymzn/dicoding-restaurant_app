import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/utility/result_state.dart';
import 'package:http/http.dart' as http;

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantAPI restaurantAPI;

  RestaurantDetailProvider({
    required this.restaurantAPI,
    required String id,
  }) {
    _fetchAllRestaurantDetail(id);
  }

  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  RestaurantDetail get detail => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  Future _fetchAllRestaurantDetail(id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await restaurantAPI.detail(id, http.Client());
      if (restaurant.restaurant.toJson().isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Tidak ada data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error => $e';
    }
  }
}
