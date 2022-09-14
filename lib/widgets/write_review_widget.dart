import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/data/restaurant_review.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/widgets/review_sent_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WriteReviewWidget extends StatefulWidget {
  late String restaurantId;

  WriteReviewWidget({super.key, required this.restaurantId});

  @override
  State<WriteReviewWidget> createState() => _WriteReviewWidgetState();
}

class _WriteReviewWidgetState extends State<WriteReviewWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController reviewController = TextEditingController();

  RestaurantAPI restaurantAPI = RestaurantAPI();

  late String review;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
    nameController.dispose();
    reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bagikan pengalaman Anda'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: SizedBox(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama :'),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nama Anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(
              height: 25,
            ),
            Text('Ulasan :'),
            TextField(
              autofocus: true,
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Bagaimana pengalaman Anda di restoran ini?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  review = value;
                });
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('BATAL'),
        ),
        TextButton(
          onPressed: () async {
            if (name != '') {
              if (review != '') {
                RestaurantAPI()
                    .addReview(widget.restaurantId, name, review)
                    .then((value) {
                  setState(() {
                    restaurantAPI = value as RestaurantAPI;
                  });
                });

                if (_connectionStatus != ConnectivityResult.none) {
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (context) => ReviewSentDialogWidget(
                      restaurantId: widget.restaurantId,
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: 'Ulasan gagal dikirim\nPeriksa koneksi internet Anda',
                    backgroundColor: Colors.brown,
                    textColor: Colors.white,
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: 'Beri ulasan terlebih dahulu',
                  backgroundColor: Colors.brown,
                  textColor: Colors.white,
                  fontSize: 16,
                  gravity: ToastGravity.CENTER,
                );
              }
            } else {
              Fluttertoast.showToast(
                msg: 'Kolom nama dan ulasan tidak boleh kosong',
                backgroundColor: Colors.brown,
                textColor: Colors.white,
                fontSize: 16,
                gravity: ToastGravity.CENTER,
              );
            }
          },
          child: Text('KIRIM'),
        ),
      ],
    );
  }
}
