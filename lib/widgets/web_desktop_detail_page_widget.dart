import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';
import 'package:dicoding_restaurant_app/detail_page.dart';

class WebDesktopDetailPageWidget extends StatelessWidget {
  final RestaurantDetail restaurantID;
  final RestaurantDetail restaurantName;
  final RestaurantDetail restaurantDescription;
  final RestaurantDetail restaurantPicture;
  final RestaurantDetail restaurantLocation;
  final RestaurantDetail restaurantRating;
  final RestaurantDetail restaurantMenu;

  final scrollController = ScrollController();

  WebDesktopDetailPageWidget({
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
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.25,
        height: MediaQuery.of(context).size.height / 1.25,
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: restaurantID.id,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(restaurantPicture.pictureId),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
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
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place,
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      restaurantLocation.city,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const FavoriteButton(),
                        ],
                      ),
                      const SizedBox(
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
                                const Align(
                                  alignment: Alignment(-1, 0),
                                  child: Text(
                                    'Deskripsi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  restaurantDescription.description,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
                                const Align(
                                  alignment: Alignment(-1, 0),
                                  child: Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Align(
                                  alignment: Alignment(-1, 0),
                                  child: Text(
                                    'Makanan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ScrollConfiguration(
                                    behavior: MyCustomScrollBehavior(),
                                    child: ListView(
                                      controller: scrollController,
                                      scrollDirection: Axis.horizontal,
                                      children: restaurantMenu.menus.foods
                                          .map((foodMenu) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                              height: 100,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              color: Colors.brown.shade200,
                                              child: Align(
                                                alignment:
                                                    const Alignment(0, 0),
                                                child: Text(
                                                  foodMenu['name'].toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
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
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Align(
                                  alignment: Alignment(-1, 0),
                                  child: Text(
                                    'Minuman',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ScrollConfiguration(
                                    behavior: MyCustomScrollBehavior(),
                                    child: ListView(
                                      controller: scrollController,
                                      scrollDirection: Axis.horizontal,
                                      children: restaurantMenu.menus.drinks
                                          .map((drinkMenu) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                              height: 100,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              color: Colors.brown.shade200,
                                              child: Align(
                                                alignment:
                                                    const Alignment(0, 0),
                                                child: Text(
                                                  drinkMenu['name'].toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
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
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
