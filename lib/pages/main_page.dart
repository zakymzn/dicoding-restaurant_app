import 'dart:async';
import 'dart:developer' as developer;
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/pages/favorite_restaurant_page.dart';
import 'package:dicoding_restaurant_app/pages/list_page.dart';
import 'package:dicoding_restaurant_app/pages/settings_page.dart';
import 'package:dicoding_restaurant_app/utility/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_restaurant_app/pages/network_disconnected_page.dart';
import 'package:dicoding_restaurant_app/pages/search_page.dart';

class MainPage extends StatefulWidget {
  static const route = '/main_page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  final pages = [
    RestaurantListPage(),
    SearchPage(),
    FavoriteRestaurantPage(),
    SettingsPage(),
  ];

  final NotificationHelper _notificationHelper = NotificationHelper();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _notificationHelper.configureSelectNotificationSubject(
        context, DetailPage.route);
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return Scaffold(
        body: pages[currentPageIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.brown.shade100,
            iconTheme: MaterialStatePropertyAll(
              IconThemeData(
                color: Colors.white,
              ),
            ),
            labelTextStyle: MaterialStatePropertyAll(
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            animationDuration: Duration(milliseconds: 500),
            selectedIndex: currentPageIndex,
            backgroundColor: Colors.brown.shade300,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.brown,
                ),
                label: 'Restoran',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(
                  Icons.search,
                  color: Colors.brown,
                ),
                label: 'Cari',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(
                  Icons.favorite,
                  color: Colors.brown,
                ),
                label: 'Favorit',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(
                  Icons.settings,
                  color: Colors.brown,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
    } else {
      return NetworkDisconnectedPage();
    }
  }
}
