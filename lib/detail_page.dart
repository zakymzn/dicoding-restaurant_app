import 'dart:ui';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/widgets/mobile_detail_page_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_detail_page_widget.dart';

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
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(restaurantDetail.restaurant.name!),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _webDesktopDetailPage(context);
        } else {
          return _mobileDetailPage(context);
        }
      }),
    );
  }

  Widget _mobileDetailPage(BuildContext context) {
    return MobileDetailPageWidget(
      restaurantDetail: restaurantDetail,
    );
  }

  Widget _webDesktopDetailPage(BuildContext context) {
    return WebDesktopDetailPageWidget(
      restaurantDetail: restaurantDetail,
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => setState(() {
        isFavorited = !isFavorited;
      }),
      icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
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
