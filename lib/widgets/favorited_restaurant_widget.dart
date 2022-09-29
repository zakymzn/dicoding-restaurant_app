import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/utility/result_state.dart';
import 'package:dicoding_restaurant_app/widgets/delete_from_favorite_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteRestaurantWidget extends StatelessWidget {
  final String favoritedRestaurantId;

  const FavoriteRestaurantWidget(
      {super.key, required this.favoritedRestaurantId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) => FutureBuilder(
        future: provider.isFavorited(favoritedRestaurantId),
        builder: (context, snapshot) {
          var isFavorited = snapshot.data ?? false;
          return ChangeNotifierProvider<RestaurantDetailProvider>(
            create: (context) => RestaurantDetailProvider(
              restaurantAPI: RestaurantAPI(),
              id: favoritedRestaurantId,
            ),
            child: Consumer<RestaurantDetailProvider>(
                builder: (context, state, child) {
              if (state.state == ResultState.loading) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.brown.shade200,
                      height: 300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              } else if (state.state == ResultState.noData) {
                return Text(state.message);
              } else if (state.state == ResultState.error) {
                return Text(state.message);
              } else {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    DetailPage.route,
                    arguments: favoritedRestaurantId,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: favoritedRestaurantId,
                              child: Image(
                                image: NetworkImage(
                                  RestaurantAPI().smallImage(
                                      state.detail.restaurant.pictureId),
                                ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const SizedBox(
                                      height: 100,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.detail.restaurant.name!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.place,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        state.detail.restaurant.city!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orangeAccent,
                                          size: 14,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          state.detail.restaurant.rating
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          color: Colors.brown,
                                          width: 1.5,
                                          height: 15,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                        ),
                                        Text(
                                            '${state.detail.restaurant.customerReviews!.length} ulasan'),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Menu makanan (${state.detail.restaurant.menus!.foods.length})',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Menu minuman (${state.detail.restaurant.menus!.drinks.length})',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Align(
                                    alignment: const Alignment(1, 0),
                                    child: Builder(
                                      builder: (context) {
                                        if (isFavorited == true) {
                                          return IconButton(
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DeleteFromFavoriteDialogWidget(
                                                    databaseProvider: provider,
                                                    favoritedRestaurantId:
                                                        favoritedRestaurantId,
                                                    restaurantDetailProvider:
                                                        state,
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.favorite),
                                          );
                                        } else {
                                          return IconButton(
                                            onPressed: () {
                                              provider.addFavorite(
                                                  favoritedRestaurantId);
                                            },
                                            icon: const Icon(
                                                Icons.favorite_border),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          );
        },
      ),
    );
  }
}
