import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/data/restaurant_review.dart';
import 'package:flutter/material.dart';

class WriteReviewWidget extends StatefulWidget {
  late String restaurantId;

  WriteReviewWidget({super.key, required this.restaurantId});

  @override
  State<WriteReviewWidget> createState() => _WriteReviewWidgetState();
}

class _WriteReviewWidgetState extends State<WriteReviewWidget> {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController reviewController = TextEditingController();

  RestaurantAPI restaurantAPI = RestaurantAPI();

  String? review;

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bagikan pengalaman Anda'),
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
          onPressed: () {
            RestaurantAPI()
                .addReview(widget.restaurantId, name, review)
                .then((value) {
              setState(() {
                restaurantAPI = value as RestaurantAPI;
              });
            });
            Navigator.pop(context);
          },
          child: Text('KIRIM'),
        ),
      ],
    );
  }
}
