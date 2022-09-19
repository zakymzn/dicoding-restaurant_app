import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/widgets/write_review_widget.dart';
import 'package:dicoding_restaurant_app/widgets/mobile_detail_page_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_detail_page_widget.dart';

class DetailPage extends StatelessWidget {
  static const route = '/detail_page';

  final String id;

  const DetailPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (context) => RestaurantDetailProvider(
        restaurantAPI: RestaurantAPI(),
        id: id,
      ),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return Container(
              color: Colors.brown.shade100,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state.state == ResultState.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(state.detail.restaurant.name!),
              ),
              body: RefreshIndicator(
                onRefresh: () => Navigator.pushReplacementNamed(
                    context, DetailPage.route,
                    arguments: state.detail.restaurant.id),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return WebDesktopDetailPageWidget(
                        restaurantDetail: state.detail.restaurant);
                  } else {
                    return MobileDetailPageWidget(
                        restaurantDetail: state.detail.restaurant);
                  }
                }),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => WriteReviewWidget(restaurantId: id),
                  );
                },
                label: const Text('Tulis ulasan'),
                icon: const Icon(Icons.edit),
              ),
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
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
