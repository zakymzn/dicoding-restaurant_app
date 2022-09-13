import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dicoding_restaurant_app/pages/network_disconnected_page.dart';
import 'package:dicoding_restaurant_app/pages/profile_page.dart';
import 'package:dicoding_restaurant_app/providers/favorite_button_provider.dart';
import 'package:dicoding_restaurant_app/pages/search_page.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_list_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/widgets/mobile_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:provider/provider.dart';

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
          // body: FutureBuilder(
          //   future: _futureRestaurantLlist,
          //   builder: (context, snapshot) {
          //     var restaurant = snapshot.data;
          //     if (snapshot.connectionState != ConnectionState.done) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else {
          //       if (snapshot.hasData) {
          //         return ListView.builder(
          //           itemCount: restaurant!.count.toInt(),
          //           itemBuilder: (context, index) {
          //             final restaurantItem = restaurant.restaurants[index];
          //             return _buildRestaurantItem(context, restaurantItem);
          //           },
          //         );
          //       } else if (snapshot.hasError) {
          //         return Center(
          //           child: Text("Data tidak berhasil dimuat"),
          //         );
          //       } else {
          //         return Text('');
          //       }
          //     }
          //   },
          // ),
          body: Consumer<RestaurantListProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.state == ResultState.hasData) {
                return ListView.builder(
                  itemCount: state.list.restaurants.length,
                  itemBuilder: (context, index) {
                    var restaurant = state.list.restaurants[index];
                    return _buildRestaurantItem(context, restaurant);
                  },
                );
              } else if (state.state == ResultState.noData) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text(''),
                );
              }
            },
          ),
        ),
      );
    } else {
      return NetworkDisconnectedPage();
    }
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailPage.route,
          arguments: restaurant.id,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _webDesktopRestaurantList(context, restaurant);
          } else {
            return _mobileRestaurantLlist(context, restaurant);
          }
        }),
      ),
    );
  }

  Widget _mobileRestaurantLlist(
      BuildContext context, Restaurant restaurantList) {
    return MobileRestaurantListWidget(
      restaurantList: restaurantList,
    );
  }

  Widget _webDesktopRestaurantList(
      BuildContext context, Restaurant restaurantList) {
    return WebDesktopRestaurantListWidget(
      restaurantList: restaurantList,
    );
  }
}
