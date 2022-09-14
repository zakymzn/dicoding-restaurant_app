import 'dart:convert';
import 'dart:io';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:dicoding_restaurant_app/data/restaurant_review.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:http/http.dart' as http;

class RestaurantAPI {
  final String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final String _list = '/list';
  final String _detail = '/detail/';
  final String _search = '/search?q=';
  final String _review = '/review';
  final String _headers = 'application/x-www-form-urlencoded';
  final String _smallImage = '/images/small/';
  final String _mediumImage = '/images/medium/';
  final String _largeImage = '/images/large/';

  Future<RestaurantList> list() async {
    final response = await http.get(Uri.parse("$_baseUrl$_list"));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetail> detail(id) async {
    final response = await http.get(Uri.parse("$_baseUrl$_detail$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearch> search(query) async {
    final response = await http.get(Uri.parse("$_baseUrl$_search$query"));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant search');
    }
  }

  Future<RestaurantReview> addReview(id, name, review) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_review'),
      headers: {'Content-Type': _headers},
      body: {
        "id": id,
        "name": name,
        "review": review,
      },
    );
    return RestaurantReview.fromJson(json.decode(response.body));
  }

  smallImage(pictureId) {
    String url = "$_baseUrl$_smallImage$pictureId";
    return url;
  }

  mediumImage(pictureId) {
    String url = "$_baseUrl$_mediumImage$pictureId";
    return url;
  }

  largeImage(pictureId) {
    String url = "$_baseUrl$_largeImage$pictureId";
    return url;
  }
}
