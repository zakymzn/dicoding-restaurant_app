import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/widgets/review_sent_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WriteReviewWidget extends StatefulWidget {
  final String restaurantId;

  const WriteReviewWidget({super.key, required this.restaurantId});

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

  String userName = name;
  String review = '';

  late FToast fToast;

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

  _showMyCustomToast(Color color, Icon icon, String text, ToastGravity gravity,
      Duration duration) {
    Widget toast = Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(text),
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
    initConnectivity();
    fToast = FToast();
    fToast.init(context);

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
      title: const Text('Bagikan pengalaman Anda'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: SizedBox(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama :'),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nama Anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Ulasan :'),
            Expanded(
              child: TextField(
                controller: reviewController,
                autofocus: true,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Bagaimana pengalaman Anda di restoran ini?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  review = value;
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('BATAL'),
        ),
        TextButton(
          onPressed: () async {
            if (userName != '') {
              if (review != '') {
                RestaurantAPI()
                    .addReview(widget.restaurantId, userName, review)
                    .then((value) {
                  restaurantAPI = value as RestaurantAPI;
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
                  _showMyCustomToast(
                    Colors.redAccent,
                    const Icon(Icons.error, color: Colors.black),
                    'Ulasan gagal dikirim\nPeriksa koneksi internet Anda',
                    ToastGravity.CENTER,
                    const Duration(seconds: 5),
                  );
                }
              } else {
                _showMyCustomToast(
                  Colors.amberAccent,
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.black,
                  ),
                  'Beri ulasan terlebih dahulu',
                  ToastGravity.CENTER,
                  const Duration(seconds: 5),
                );
              }
            } else {
              _showMyCustomToast(
                Colors.amberAccent,
                const Icon(
                  Icons.warning_rounded,
                  color: Colors.black,
                ),
                'Kolom nama dan ulasan tidak boleh kosong',
                ToastGravity.CENTER,
                const Duration(seconds: 5),
              );
            }
          },
          child: const Text('KIRIM'),
        ),
      ],
    );
  }
}
