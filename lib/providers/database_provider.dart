import 'package:flutter/foundation.dart';
import 'package:dicoding_restaurant_app/db/database_helper.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';

enum ResultState { loading, hasData, noData, error }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorite();
  }

  late ResultState _state;
  String _message = '';
  List<Restaurant> _favorited = [];

  ResultState get state => _state;
  String get message => _message;
  List<Restaurant> get favorited => _favorited;

  void _getFavorite() async {
    _favorited = await databaseHelper.getFavorite();
    if (_favorited.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tidak ada data';
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurantDetail) async {
    try {
      await databaseHelper.addFavorite(restaurantDetail);
      _getFavorite();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }
}
