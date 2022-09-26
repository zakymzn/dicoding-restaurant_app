import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/widgets/add_to_favorite_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:provider/provider.dart';

class MobileRestaurantListWidget extends StatelessWidget {
  final Restaurant restaurantList;

  const MobileRestaurantListWidget({
    super.key,
    required this.restaurantList,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) => FutureBuilder(
        future: provider.isFavorited(restaurantList.id!),
        builder: (context, snapshot) {
          var isFavorited = snapshot.data ?? false;
          return GestureDetector(
            onLongPress: () async {
              await showDialog(
                context: context,
                builder: (context) => AddToFavoriteDialogWidget(
                  provider: provider,
                  favoritedRestaurantId: restaurantList.id!,
                  isFavorited: isFavorited,
                ),
              );
            },
            child: SizedBox(
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
                              tag: restaurantList.id!,
                              child: Image(
                                image: NetworkImage(
                                  RestaurantAPI()
                                      .smallImage(restaurantList.pictureId),
                                ),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 80,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
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
                                restaurantList.name!,
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
                                    restaurantList.city!,
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
                                  Text(restaurantList.rating.toString()),
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
          );
        },
      ),
    );
  }
}
