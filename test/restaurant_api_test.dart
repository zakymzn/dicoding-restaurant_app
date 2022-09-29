import 'dart:convert';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  group(
    'Testing Restaurant API',
    () {
      test(
        'for Restaurant List',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "message": "success",
                "count": 20,
                "restaurants": []
              };
              return Response(json.encode(response), 200);
            },
          );

          expect(await RestaurantAPI().list(client), isA<RestaurantList>());
        },
      );

      test(
        'for Restaurant Detail when restaurant id is found',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "message": "success",
                "restaurant": {
                  "id": "",
                  "name": "",
                  "description": "",
                  "city": "",
                  "address": "",
                  "pictureId": "",
                  "categories": [],
                  "menus": {"foods": [], "drinks": []},
                  "rating": 1.0,
                  "customerReviews": []
                }
              };
              return Response(json.encode(response), 200);
            },
          );

          expect(await RestaurantAPI().detail('Restaurant Id Example', client),
              isA<RestaurantDetail>());
        },
      );

      test(
        'for Restaurant Detail when restaurant id is not found',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": true,
                "message": "restaurant not found"
              };
              return Response(json.encode(response), 200);
            },
          );

          expect(
              await RestaurantAPI().detailNotFound('Random Id Example', client),
              isA<RestaurantDetailNotFound>());
        },
      );

      test(
        'for Restaurant Search',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "founded": 1,
                "restaurants": []
              };
              return Response(json.encode(response), 200);
            },
          );

          expect(
              await RestaurantAPI().search('Restaurant Name Example', client),
              isA<RestaurantSearch>());
        },
      );
    },
  );
}
