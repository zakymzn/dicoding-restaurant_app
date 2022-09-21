import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/providers/favorite_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final RestaurantDetail restaurantDetail;
  const FavoriteButton({super.key, required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    bool isFavorited = Provider.of<FavoriteButtonProvider>(context).isFavorited;
    return Consumer<DatabaseProvider>(
      builder: (context, value, child) {
        return IconButton(
          onPressed: () {
            if (isFavorited == true) {
              Provider.of<FavoriteButtonProvider>(context, listen: false)
                  .changeFavoriteButton(false);
              value.removeFavorite(restaurantDetail.restaurant.id!);
            } else {
              Provider.of<FavoriteButtonProvider>(context, listen: false)
                  .changeFavoriteButton(true);
              value.addFavorite(restaurantDetail);
            }
          },
          icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
        );
      },
    );
  }
}
