import 'package:flutter/material.dart';

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
              // backgroundColor: Colors.brown,
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
        body: Container());
  }
}
