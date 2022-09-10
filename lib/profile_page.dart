import 'package:dicoding_restaurant_app/widgets/mobile_profile_page.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Profil'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return WebDesktopProfilePage();
          } else {
            return MobileProfileScreen();
          }
        },
      ),
    );
  }
}
