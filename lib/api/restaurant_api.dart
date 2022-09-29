import 'dart:convert';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:dicoding_restaurant_app/data/restaurant_review.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:http/http.dart' as http;

class RestaurantAPI {
  final String baseUrl = 'https://restaurant-api.dicoding.dev';
  final String listUrl = '/list';
  final String detailUrl = '/detail/';
  final String searchUrl = '/searchq=';
  final String reviewUrl = '/review';
  final String headers = 'application/x-www-form-urlencoded';
  final String smallImageUrl = '/images/small/';
  final String mediumImageUrl = '/images/medium/';
  final String largeImageUrl = '/images/large/';

  Future<RestaurantList> list(http.Client client) async {
    final response = await client.get(Uri.parse("$baseUrl$listUrl"));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetail> detail(id, http.Client client) async {
    final response = await client.get(Uri.parse("$baseUrl$detailUrl$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantDetailNotFound> detailNotFound(
      id, http.Client client) async {
    final response = await client.get(Uri.parse("$baseUrl$detailUrl$id"));
    if (response.statusCode == 200) {
      return RestaurantDetailNotFound.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearch> search(query, http.Client client) async {
    final response = await client.get(Uri.parse("$baseUrl$searchUrl$query"));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant search');
    }
  }

  Future<RestaurantReview> addReview(id, name, review) async {
    final response = await http.post(
      Uri.parse('$baseUrl$reviewUrl'),
      headers: {'Content-Type': headers},
      body: {
        "id": id,
        "name": name,
        "review": review,
      },
    );
    return RestaurantReview.fromJson(json.decode(response.body));
  }

  smallImage(pictureId) {
    String url = "$baseUrl$smallImageUrl$pictureId";
    return url;
  }

  mediumImage(pictureId) {
    String url = "$baseUrl$mediumImageUrl$pictureId";
    return url;
  }

  largeImage(pictureId) {
    String url = "$baseUrl$largeImageUrl$pictureId";
    return url;
  }
}
