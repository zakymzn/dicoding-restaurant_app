import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';

class DetailPage extends StatelessWidget {
  static const route = '/detail_page';

  final RestaurantDetail restaurantDetail;

  const DetailPage({super.key, required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(restaurantDetail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(restaurantDetail.pictureId),
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
                            restaurantDetail.name,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 18,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  restaurantDetail.city,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.favorite))
                    ],
                  ),
                  Align(
                    alignment: Alignment(-1, 0),
                    child: Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    restaurantDetail.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
