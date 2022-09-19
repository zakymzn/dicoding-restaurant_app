import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:flutter/material.dart';

class ReviewSentDialogWidget extends StatefulWidget {
  final String restaurantId;

  const ReviewSentDialogWidget({super.key, required this.restaurantId});

  @override
  State<ReviewSentDialogWidget> createState() => _ReviewSentDialogWidgetState();
}

class _ReviewSentDialogWidgetState extends State<ReviewSentDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              width: 200,
              child: Image(
                image: AssetImage('images/success.gif'),
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Ulasan berhasil dikirim!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, DetailPage.route,
                arguments: widget.restaurantId);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
