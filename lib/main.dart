import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/main_page.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant App",
      home: MainPage(),
    );
  }
}
