import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/pages/network_disconnected_page.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_search_provider.dart';
import 'package:dicoding_restaurant_app/widgets/search_result_widget.dart';

class SearchPage extends StatefulWidget {
  static const route = '/search_page';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textEditingController;

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

    final RestaurantSearchProvider restaurantSearchProvider =
        Provider.of<RestaurantSearchProvider>(context, listen: false);

    textEditingController =
        TextEditingController(text: restaurantSearchProvider.query);

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
            icon: const Icon(Icons.arrow_back),
          ),
          title: Consumer<RestaurantSearchProvider>(
            builder: (context, state, _) => TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Cari restoran di sini',
                hintStyle: TextStyle(
                  color: Colors.white30,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: Colors.brown.shade100,
              onChanged: (value) {
                Provider.of<RestaurantSearchProvider>(context, listen: false)
                    .searchRestaurant(value);
              },
            ),
          ),
          elevation: 2,
        ),
        body: Consumer<RestaurantSearchProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Sedang mencari restoran untuk Anda'),
                  ],
                ),
              );
            } else if (state.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: state.search.founded.toInt(),
                itemBuilder: (context, index) {
                  final restaurantFounded = state.search.restaurants[index];
                  return SearchResultWidget(
                      restaurantFounded: restaurantFounded);
                },
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      MdiIcons.storeSearch,
                      size: 75,
                      color: Colors.brown,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Cari restoran yang Anda inginkan',
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
          },
        ),
      );
    } else {
      return const NetworkDisconnectedPage();
    }
  }
}
