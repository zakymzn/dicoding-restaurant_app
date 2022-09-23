import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
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
                return _buildFavoritedRestaurantItem(
                    context, favoritedRestaurantList);
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
      BuildContext context, Restaurant favoritedRestaurantList) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) => FutureBuilder<bool>(
        builder: (context, snapshot) {
          var isFavorited = snapshot.data ?? false;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                DetailPage.route,
                arguments: favoritedRestaurantList.id,
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
                                    tag: favoritedRestaurantList.id!,
                                    child: Image(
                                      image: NetworkImage(
                                        RestaurantAPI().smallImage(
                                            favoritedRestaurantList.pictureId),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favoritedRestaurantList.name!,
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
                                          favoritedRestaurantList.city!,
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
                                        Text(favoritedRestaurantList.rating
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
                                return provider.removeFavorite(
                                    favoritedRestaurantList.id!);
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
        },
      ),
    );
  }
}
