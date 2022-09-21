import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/widgets/profile_url_widget.dart';
import 'package:flutter/material.dart';

class WebDesktopProfilePage extends StatelessWidget {
  const WebDesktopProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.25,
        height: MediaQuery.of(context).size.height / 1.5,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.brown.shade200,
                  child: ListView(
                    children: [
                      Hero(
                        tag: 'profile',
                        child: Center(
                          heightFactor: 1.25,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 10,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(profileImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.brown.shade200,
                  child: ListView.builder(
                    itemCount: socialMediaList.length,
                    itemBuilder: (context, index) {
                      final SocialMedia socialMedia = socialMediaList[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ProfileUrlWidget(
                            icon: socialMedia.icon,
                            socialMediaName: socialMedia.socialMediaName,
                            url: socialMedia.url),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
