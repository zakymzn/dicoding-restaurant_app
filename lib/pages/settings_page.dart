import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/pages/profile_page.dart';
import 'package:dicoding_restaurant_app/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.brown.shade200,
              ),
              title: const Text(
                'Settings',
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            ),
          )
        ];
      },
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, ProfilePage.route),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'profile',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(profileImage),
                      radius: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 64,
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.brown,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: Colors.brown,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, notification, _) {
                      return Switch.adaptive(
                        value: notification.notificationSwitchCondition,
                        onChanged: (value) async {
                          notification.changeNotificationSwitchCondition(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
