import 'dart:ui';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/widgets/mobile_detail_page_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_detail_page_widget.dart';

class DetailPage extends StatefulWidget {
  static const route = '/detail_page';

  String? id;

  DetailPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RestaurantAPI().detail(widget.id),
      builder: (context, snapshot) {
        var restaurant = snapshot.data!.restaurant;
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return WebDesktopDetailPageWidget(restaurantDetail: restaurant);
              } else {
                return MobileDetailPageWidget(restaurantDetail: restaurant);
              }
            });
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Data tidak berhasil dimuat"),
            );
          } else {
            return Text('');
          }
        }
      },
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
