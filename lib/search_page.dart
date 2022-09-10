import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:dicoding_restaurant_app/main.dart';
import 'package:dicoding_restaurant_app/network_disconnected_page.dart';
import 'package:dicoding_restaurant_app/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchPage extends StatefulWidget {
  static const route = '/search_page';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();

  String? query;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

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
  void dispose() {
    super.dispose();

    subscription.cancel();
    textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
          title: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Cari restoran di sini',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
            cursorColor: Colors.brown.shade100,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
          elevation: 2,
        ),
        body: FutureBuilder(
          future: RestaurantAPI().search(query),
          builder: (context, snapshot) {
            var restaurant = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Sedang mencari restoran untuk Anda'),
                  ],
                ),
              );
            } else {
              if (snapshot.hasData) {
                if (restaurant!.founded > 0) {
                  return ListView.builder(
                    itemCount: restaurant.founded.toInt(),
                    itemBuilder: (context, index) {
                      final restaurantFounded = restaurant.restaurants[index];
                      return SearchResultWidget(
                          restaurantFounded: restaurantFounded);
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.emoticonConfused,
                          size: 75,
                          color: Colors.brown,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Restoran yang Anda cari tidak ditemukan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.storeSearch,
                        size: 75,
                        color: Colors.brown,
                      ),
                      Text(
                        'Cari restoran yang anda inginkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      );
    } else {
      return NetworkDisconnectedPage();
    }
  }
}
