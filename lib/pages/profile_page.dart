import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/pages/mobile/mobile_profile_page_widget.dart';
import 'package:dicoding_restaurant_app/pages/web_desktop/web_desktop_profile_page.dart';

class ProfilePage extends StatelessWidget {
  static const route = '/profile_page';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Profil'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return const WebDesktopProfilePage();
          } else {
            return const MobileProfileScreen();
          }
        },
      ),
    );
  }
}
