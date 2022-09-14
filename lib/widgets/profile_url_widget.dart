import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileUrlWidget extends StatelessWidget {
  final IconData icon;
  final String socialMediaName;
  final String url;

  const ProfileUrlWidget({
    super.key,
    required this.icon,
    required this.socialMediaName,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ElevatedButton(
          onPressed: () async {
            final link = Uri.parse(url);
            if (await canLaunchUrl(link)) {
              await launchUrl(link);
            } else {
              throw "Could not launch $link";
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  socialMediaName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
