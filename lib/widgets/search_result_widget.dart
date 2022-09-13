import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:flutter/material.dart';

class SearchResultWidget extends StatelessWidget {
  final Restaurant restaurantFounded;

  const SearchResultWidget({
    super.key,
    required this.restaurantFounded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.brown.shade200,
          child: ListTile(
            leading: Hero(
              tag: restaurantFounded.id!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Image(
                    image: NetworkImage(
                      RestaurantAPI().smallImage(restaurantFounded.pictureId),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Text(restaurantFounded.name!),
            subtitle: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.place,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  restaurantFounded.city!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, DetailPage.route,
                arguments: restaurantFounded.id),
          ),
        ),
      ),
    );
  }
}
