import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dicoding_restaurant_app/profile_page.dart';
import 'package:dicoding_restaurant_app/search_page.dart';
import 'package:http/http.dart' as http;
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_restaurant_app/detail_page.dart';
import 'package:dicoding_restaurant_app/widgets/mobile_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';

class MainPage extends StatefulWidget {
  static const route = '/main_page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  late Future<RestaurantList> _futureRestaurantLlist;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
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
    _futureRestaurantLlist = RestaurantAPI().list();

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return networkConnected(context);
    } else {
      return networkDisconnected(context);
    }
  }

  Widget networkConnected(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              elevation: 2,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "images/large_compressed.jpg",
                  fit: BoxFit.cover,
                ),
                title: const Text(
                  "Restaurant",
                ),
                titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.route);
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProfilePage.route);
                  },
                  iconSize: 30,
                  icon: Hero(
                    tag: 'profile',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('images/profile.jpg'),
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        body: FutureBuilder(
          future: _futureRestaurantLlist,
          builder: (context, snapshot) {
            var restaurant = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: restaurant!.count.toInt(),
                  itemBuilder: (context, index) {
                    final restaurantItem = restaurant.restaurants[index];
                    return _buildRestaurantItem(context, restaurantItem);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Data tidak berhasil dimuat"),
                );
              } else {
                return Text('');
              }
            }
          },
        ),
      ),
    );
  }

  Widget networkDisconnected(BuildContext context) {
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

  Widget _buildRestaurantItem(
      BuildContext context, Restaurant restaurantDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailPage.route,
          arguments: restaurantDetail,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _webDesktopRestaurantList(context, restaurantDetail);
          } else {
            return _mobileRestaurantLlist(context, restaurantDetail);
          }
        }),
      ),
    );
  }

  Widget _mobileRestaurantLlist(
      BuildContext context, Restaurant restaurantDetail) {
    return MobileRestaurantListWidget(
      restaurantID: restaurantDetail,
      restaurantName: restaurantDetail,
      restaurantPicture: restaurantDetail,
      restaurantLocation: restaurantDetail,
      restaurantRating: restaurantDetail,
    );
  }

  Widget _webDesktopRestaurantList(
      BuildContext context, Restaurant restaurantDetail) {
    return WebDesktopRestaurantListWidget(
      restaurantID: restaurantDetail,
      restaurantName: restaurantDetail,
      restaurantPicture: restaurantDetail,
      restaurantLocation: restaurantDetail,
      restaurantRating: restaurantDetail,
    );
  }
}
