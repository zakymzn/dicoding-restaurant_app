import 'package:dicoding_restaurant_app/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  static const route = '/main_page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "images/large_compressed.jpg",
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Restaurant",
                ),
                titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              ),
            ),
          ];
        },
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('assets/local_restaurant.json'),
          builder: <String>(context, snapshot) {
            final List<RestaurantDetail> restaurantDetail =
                parseRestaurantDetail(snapshot.data);

            return ListView.builder(
              itemCount: restaurantDetail.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(context, restaurantDetail[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context, RestaurantDetail restaurantDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailPage.route,
          arguments: restaurantDetail,
        ),
        child: SizedBox(
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: NetworkImage(restaurantDetail.pictureId),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 80,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantDetail.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.place,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                restaurantDetail.city,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                              Text(restaurantDetail.rating.toString()),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// final restaurant = restaurantFromJson('assets/local_restaurant.json');
// void main() {
//   print(restaurant);
// }
