import 'package:dicoding_restaurant_app/widgets/mobile_detail_page_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_detail_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';

class DetailPage extends StatelessWidget {
  static const route = '/detail_page';

  final RestaurantDetail restaurantDetail;

  DetailPage({super.key, required this.restaurantDetail});

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
      restaurantID: restaurantDetail,
      restaurantName: restaurantDetail,
      restaurantDescription: restaurantDetail,
      restaurantPicture: restaurantDetail,
      restaurantLocation: restaurantDetail,
      restaurantRating: restaurantDetail,
      restaurantMenu: restaurantDetail,
    );
  }

  Widget _webDesktopDetailPage(BuildContext context) {
    return WebDesktopDetailPageWidget(
      restaurantID: restaurantDetail,
      restaurantName: restaurantDetail,
      restaurantDescription: restaurantDetail,
      restaurantPicture: restaurantDetail,
      restaurantLocation: restaurantDetail,
      restaurantRating: restaurantDetail,
      restaurantMenu: restaurantDetail,
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
