import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/providers/favorite_button_provider.dart';
import 'package:dicoding_restaurant_app/widgets/favorite_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:provider/provider.dart';

class MobileDetailPageWidget extends StatelessWidget {
  final RestaurantDetail restaurantDetail;

  MobileDetailPageWidget({
    super.key,
    required this.restaurantDetail,
  });

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: restaurantDetail.restaurant.id!,
            child: Image(
              image: NetworkImage(
                RestaurantAPI()
                    .largeImage(restaurantDetail.restaurant.pictureId!),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantDetail.restaurant.name!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<DatabaseProvider>(
                      builder: (context, provider, child) => FutureBuilder(
                        future: provider
                            .isFavorited(restaurantDetail.restaurant.id!),
                        builder: (context, snapshot) {
                          var isFavorited = snapshot.data ?? false;
                          // return isFavorited
                          //     ? IconButton(
                          //         onPressed: () => provider.removeFavorite(
                          //             restaurantDetail.restaurant.id!),
                          //         icon: Icon(Icons.favorite),
                          //       )
                          //     : IconButton(
                          //         onPressed: () =>
                          //             provider.addFavorite(restaurantDetail),
                          //         icon: Icon(Icons.favorite_border),
                          //       );
                          if (isFavorited == true) {
                            return IconButton(
                              onPressed: () => provider.removeFavorite(
                                  restaurantDetail.restaurant.id!),
                              icon: Icon(Icons.favorite),
                            );
                          } else {
                            return IconButton(
                              onPressed: () =>
                                  provider.addFavorite(restaurantDetail),
                              icon: Icon(Icons.favorite_border),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.place,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantDetail.restaurant.city!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            restaurantDetail.restaurant.address!,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Rating",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2.5),
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
                              restaurantDetail.restaurant.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
                              'Kategori',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 36,
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: restaurantDetail
                                    .restaurant.categories!.length,
                                itemBuilder: (context, index) {
                                  final categories = restaurantDetail
                                      .restaurant.categories![index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        color: Colors.brown.shade200,
                                        child: Align(
                                          alignment: const Alignment(0, 0),
                                          child: Text(
                                            categories.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            restaurantDetail.restaurant.description!,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Makanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                                children: restaurantDetail
                                    .restaurant.menus!.foods
                                    .map((foodMenu) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: 100,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        color: Colors.brown.shade200,
                                        child: Center(
                                          child: Text(
                                            foodMenu.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
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
                          const Text(
                            'Minuman',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                                children: restaurantDetail
                                    .restaurant.menus!.drinks
                                    .map((drinkMenu) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: 100,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        color: Colors.brown.shade200,
                                        child: Center(
                                          child: Text(
                                            drinkMenu.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ulasan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: restaurantDetail
                                .restaurant.customerReviews!.length,
                            itemBuilder: (context, index) {
                              final review = restaurantDetail
                                  .restaurant.customerReviews![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    color: Colors.brown.shade200,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                review.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              review.date,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          review.review,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
