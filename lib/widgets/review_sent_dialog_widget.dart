import 'dart:async';

import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:flutter/material.dart';

class ReviewSentDialogWidget extends StatefulWidget {
  late String restaurantId;

  ReviewSentDialogWidget({super.key, required this.restaurantId});

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
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/success.gif'),
            ),
            Text(
              'Ulasan berhasil dikirim!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
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
          child: Text('OK'),
        ),
      ],
    );
  }
}
