import 'package:dicoding_restaurant_app/pages/main_page.dart';
import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteFromFavoriteDialogWidget extends StatelessWidget {
  DatabaseProvider provider;
  String favoritedRestaurantId;

  DeleteFromFavoriteDialogWidget({
    super.key,
    required this.provider,
    required this.favoritedRestaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Text(
        'Anda yakin ingin menghapus restoran ini dari daftar favorit?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('TIDAK'),
        ),
        TextButton(
          onPressed: () {
            provider.removeFavorite(favoritedRestaurantId);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
            Fluttertoast.showToast(
              msg: 'Restoran telah dihapus dari daftar favorit',
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              gravity: ToastGravity.SNACKBAR,
            );
          },
          child: Text('YA'),
        ),
      ],
    );
  }
}
