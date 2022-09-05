import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';

class MobileRestaurantListWidget extends StatefulWidget {
  final RestaurantDetail restaurantID;
  final RestaurantDetail restaurantName;
  final RestaurantDetail restaurantPicture;
  final RestaurantDetail restaurantLocation;
  final RestaurantDetail restaurantRating;

  const MobileRestaurantListWidget({
    super.key,
    required this.restaurantID,
    required this.restaurantName,
    required this.restaurantPicture,
    required this.restaurantLocation,
    required this.restaurantRating,
  });

  @override
  State<MobileRestaurantListWidget> createState() =>
      _MobileRestaurantListWidgetState();
}

class _MobileRestaurantListWidgetState
    extends State<MobileRestaurantListWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: widget.restaurantID.id,
                      child: Image(
                        image: NetworkImage(widget.restaurantPicture.pictureId),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 80,
                      ),
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
                        widget.restaurantName.name,
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
                            widget.restaurantLocation.city,
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
                          Text(widget.restaurantRating.rating.toString()),
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
    );
    ;
  }
}
