import 'package:dicoding_restaurant_app/data/profile_data.dart';
import 'package:dicoding_restaurant_app/pages/profile_page.dart';
import 'package:dicoding_restaurant_app/providers/scheduling_provider.dart';
import 'package:dicoding_restaurant_app/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          Consumer<SettingsProvider>(
            builder: (context, provider, child) {
              return ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.brown,
                  size: 30,
                ),
                title: const Text(
                  'Notifikasi rekomendasi restoran',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, child) {
                    return Switch.adaptive(
                      value: provider.notificationSwitchCondition,
                      onChanged: (value) async {
                        scheduled.scheduledNotification(value);
                        provider.changeNotificationSwitchCondition(value);
                        if (value == true) {
                          Fluttertoast.showToast(
                            msg: 'Rekomendasi diaktifkan',
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Colors.brown,
                            textColor: Colors.white,
                          );
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
