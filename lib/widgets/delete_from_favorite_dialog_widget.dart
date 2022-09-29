import 'package:dicoding_restaurant_app/pages/main_page.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteFromFavoriteDialogWidget extends StatelessWidget {
  final DatabaseProvider databaseProvider;
  final RestaurantDetailProvider restaurantDetailProvider;
  final String favoritedRestaurantId;

  const DeleteFromFavoriteDialogWidget({
    super.key,
    required this.databaseProvider,
    required this.restaurantDetailProvider,
    required this.favoritedRestaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Text(
        'Anda yakin ingin menghapus restoran ${restaurantDetailProvider.detail.restaurant.name} dari daftar favorit?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('TIDAK'),
        ),
        TextButton(
          onPressed: () {
            databaseProvider.removeFavorite(favoritedRestaurantId);
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
            Fluttertoast.showToast(
              msg:
                  'Restoran ${restaurantDetailProvider.detail.restaurant.name} telah dihapus dari daftar favorit',
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              gravity: ToastGravity.SNACKBAR,
            );
          },
          child: const Text('YA'),
        ),
      ],
    );
  }
}
