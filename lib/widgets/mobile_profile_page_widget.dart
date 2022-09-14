import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/widgets/profile_url_widget.dart';
import 'package:flutter/material.dart';

class MobileProfileScreen extends StatelessWidget {
  const MobileProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Hero(
                  tag: 'profile',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('images/profile.jpg'),
                    radius: 35,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 13, color: Colors.brown),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: socialMediaList.length,
              itemBuilder: (context, index) {
                final SocialMedia socialMedia = socialMediaList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProfileUrlWidget(
                      icon: socialMedia.icon,
                      socialMediaName: socialMedia.socialMediaName,
                      url: socialMedia.url),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
