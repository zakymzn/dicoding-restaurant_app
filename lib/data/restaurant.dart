import 'dart:convert';

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final Menus menus;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> restaurantDetail) {
    return RestaurantDetail(
      id: restaurantDetail['id'],
      name: restaurantDetail['name'],
      description: restaurantDetail['description'],
      pictureId: restaurantDetail['pictureId'],
      city: restaurantDetail['city'],
      rating: double.parse(restaurantDetail['rating'].toString()),
      menus: Menus.fromJson(restaurantDetail['menus']),
    );
  }
}

class Menus {
  final List foods;
  final List drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> menus) => Menus(
        foods: List.from(menus['foods']),
        drinks: List.from(menus['drinks']),
      );
}

class FoodAndDrink {
  final String name;

  FoodAndDrink({required this.name});

  factory FoodAndDrink.fromJson(Map foodAndDrink) => FoodAndDrink(
        name: foodAndDrink['name'],
      );
}

List<RestaurantDetail> parseRestaurantDetail(json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed = jsonDecode(json);
  List<dynamic> restaurants = parsed['restaurants'];
  return restaurants.map((json) => RestaurantDetail.fromJson(json)).toList();
}
