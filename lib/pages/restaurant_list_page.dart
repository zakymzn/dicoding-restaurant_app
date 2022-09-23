import 'package:dicoding_restaurant_app/pages/mobile/mobile_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/pages/web_desktop/web_desktop_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/utility/result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_list_provider.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
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
              background: Image.asset(
                "images/large_compressed.jpg",
                fit: BoxFit.cover,
              ),
              title: const Text(
                "Restaurant",
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            ),
          ),
        ];
      },
      body: Consumer<RestaurantListProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: state.list.restaurants.length,
              itemBuilder: (context, index) {
                var restaurantList = state.list.restaurants[index];
                return _buildRestaurantItem(context, restaurantList);
              },
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text(''),
            );
          }
        },
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurantList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailPage.route,
          arguments: restaurantList.id,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return WebDesktopRestaurantListWidget(
                restaurantList: restaurantList);
          } else {
            return MobileRestaurantListWidget(restaurantList: restaurantList);
          }
        }),
      ),
    );
  }
}
