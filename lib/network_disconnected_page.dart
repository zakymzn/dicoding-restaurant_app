import 'package:flutter/material.dart';

class NetworkDisconnectedPage extends StatelessWidget {
  const NetworkDisconnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.signal_cellular_connected_no_internet_0_bar,
                size: 50,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Anda tidak terhubung ke internet\nPeriksa koneksi internet Anda!',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
