import 'package:dicoding_restaurant_app/data/restaurant.dart';
import 'package:dicoding_restaurant_app/detail_page.dart';
import 'package:flutter/material.dart';

class MobileDetailPageWidget extends StatelessWidget {
  final RestaurantDetail restaurantID;
  final RestaurantDetail restaurantName;
  final RestaurantDetail restaurantDescription;
  final RestaurantDetail restaurantPicture;
  final RestaurantDetail restaurantLocation;
  final RestaurantDetail restaurantRating;
  final RestaurantDetail restaurantMenu;

  const MobileDetailPageWidget({
    super.key,
    required this.restaurantID,
    required this.restaurantName,
    required this.restaurantDescription,
    required this.restaurantPicture,
    required this.restaurantLocation,
    required this.restaurantRating,
    required this.restaurantMenu,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: restaurantID.id,
            child: Image(
              image: NetworkImage(restaurantPicture.pictureId),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantName.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                restaurantLocation.city,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    FavoriteButton(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(-1, 0),
                            child: Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            restaurantDescription.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(-1, 0),
                            child: Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment(-1, 0),
                            child: Text(
                              'Makanan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  restaurantMenu.menus.foods.map((foodMenu) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 100,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      color: Colors.brown.shade200,
                                      child: Align(
                                        alignment: Alignment(0, 0),
                                        child: Text(
                                          foodMenu['name'].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment(-1, 0),
                            child: Text(
                              'Minuman',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  restaurantMenu.menus.drinks.map((drinkMenu) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 100,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      color: Colors.brown.shade200,
                                      child: Align(
                                        alignment: Alignment(0, 0),
                                        child: Text(
                                          drinkMenu['name'].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
