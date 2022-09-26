import 'package:dicoding_restaurant_app/pages/favorite_restaurant_page.dart';
import 'package:dicoding_restaurant_app/pages/list_page.dart';
import 'package:dicoding_restaurant_app/pages/search_page.dart';
import 'package:dicoding_restaurant_app/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> pages = [
    RestaurantListPage(),
    SearchPage(),
    FavoriteRestaurantPage(),
    SettingsPage(),
  ];

  currentPageIndex(int page) {
    currentIndex = page;
    notifyListeners();
  }
}
