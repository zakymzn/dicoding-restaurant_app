import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/utility/result_state.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class FavoriteRestaurantPage extends StatelessWidget {
  const FavoriteRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Restoran Favorit'),
              background: Container(
                color: Colors.brown.shade200,
              ),
              titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
            ),
          ),
        ];
      },
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: provider.favorited.length,
              itemBuilder: (context, index) {
                var favoritedRestaurantList = provider.favorited[index];
                return FutureBuilder(
                  future: provider.isFavorited(favoritedRestaurantList),
                  builder: (context, snapshot) {
                    var isFavorited = snapshot.data ?? false;
                    return _buildFavoritedRestaurantItem(context,
                        favoritedRestaurantList, isFavorited, provider);
                  },
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.food,
                  size: 75,
                  color: Colors.brown,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Belum ada restoran yang Anda favoritkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFavoritedRestaurantItem(
      BuildContext context,
      String favoritedRestaurantList,
      bool isFavorited,
      DatabaseProvider provider) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (context) => RestaurantDetailProvider(
        restaurantAPI: RestaurantAPI(),
        id: favoritedRestaurantList,
      ),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, child) {
          if (state.state == ResultState.loading) {
            return Container(
              color: Colors.brown.shade200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state.state == ResultState.error) {
            return Text(state.message);
          } else if (state.state == ResultState.noData) {
            return Text(state.message);
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  DetailPage.route,
                  arguments: favoritedRestaurantList,
                ),
                child: SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Hero(
                                      tag: favoritedRestaurantList,
                                      child: Image(
                                        image: NetworkImage(
                                          RestaurantAPI().smallImage(state
                                              .detail.restaurant.pictureId),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 80,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return SizedBox(
                                              width: 100,
                                              height: 80,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.detail.restaurant.name!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.place,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            state.detail.restaurant.city!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                          Text(state.detail.restaurant.rating
                                              .toString())
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                if (isFavorited == true) {
                                  return provider
                                      .removeFavorite(favoritedRestaurantList);
                                } else {
                                  return provider
                                      .addFavorite(favoritedRestaurantList);
                                }
                              },
                              icon: isFavorited
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
