import 'package:dicoding_restaurant_app/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddToFavoriteDialogWidget extends StatefulWidget {
  DatabaseProvider provider;
  String favoritedRestaurantId;
  bool isFavorited;

  AddToFavoriteDialogWidget({
    super.key,
    required this.provider,
    required this.favoritedRestaurantId,
    required this.isFavorited,
  });

  @override
  State<AddToFavoriteDialogWidget> createState() =>
      _AddToFavoriteDialogWidgetState();
}

class _AddToFavoriteDialogWidgetState extends State<AddToFavoriteDialogWidget> {
  late FToast fToast;

  _showMyCustomToast(Color backgroundColor, Icon icon, String text,
      Color textColor, ToastGravity gravity, Duration duration) {
    Widget toast = Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: duration,
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Text(
        'Tambahkan restoran ini ke daftar favorit?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('TIDAK'),
        ),
        TextButton(
          onPressed: () {
            if (widget.isFavorited == true) {
              Navigator.pop(context);
              _showMyCustomToast(
                Colors.red,
                const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                ),
                'Restorant ini sudah ditambahkan sebelumnya',
                Colors.white,
                ToastGravity.BOTTOM,
                Duration(seconds: 3),
              );
            } else {
              widget.provider.addFavorite(widget.favoritedRestaurantId);
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Restoran berhasil ditambahkan ke daftar favorit',
                backgroundColor: Colors.brown,
                textColor: Colors.white,
                gravity: ToastGravity.SNACKBAR,
              );
            }
          },
          child: Text('YA'),
        ),
      ],
    );
  }
}
