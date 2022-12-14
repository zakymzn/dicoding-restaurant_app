import 'package:dicoding_restaurant_app/pages/main_page.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/utility/result_state.dart';
import 'package:dicoding_restaurant_app/widgets/favorited_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoriteRestaurantPage extends StatefulWidget {
  const FavoriteRestaurantPage({super.key});

  @override
  State<FavoriteRestaurantPage> createState() => _FavoriteRestaurantPageState();
}

class _FavoriteRestaurantPageState extends State<FavoriteRestaurantPage> {
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
              title: const Text('Restoran Favorit'),
              background: Container(
                color: Colors.brown.shade200,
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            ),
          ),
        ];
      },
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.hasData) {
            return RefreshIndicator(
              onRefresh: () {
                return Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ));
              },
              child: MasonryGridView.builder(
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                padding: const EdgeInsets.all(5),
                itemCount: provider.favorited.length,
                itemBuilder: (context, index) {
                  var favoritedRestaurantList = provider.favorited[index];
                  return FavoriteRestaurantWidget(
                      favoritedRestaurantId: favoritedRestaurantList);
                },
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
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
}
