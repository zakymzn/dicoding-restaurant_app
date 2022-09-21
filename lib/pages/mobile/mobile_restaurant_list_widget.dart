import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';

class MobileRestaurantListWidget extends StatefulWidget {
  final Restaurant restaurantList;

  const MobileRestaurantListWidget({
    super.key,
    required this.restaurantList,
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
                      tag: widget.restaurantList.id!,
                      child: Image(
                        image: NetworkImage(
                          RestaurantAPI()
                              .smallImage(widget.restaurantList.pictureId),
                        ),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 80,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const SizedBox(
                              width: 100,
                              height: 80,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
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
                        widget.restaurantList.name!,
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
                            widget.restaurantList.city!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          Text(widget.restaurantList.rating.toString()),
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
  }
}
