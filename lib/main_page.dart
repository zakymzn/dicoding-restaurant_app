import 'package:dicoding_restaurant_app/detail_page.dart';
import 'package:dicoding_restaurant_app/widgets/mobile_restaurant_list_widget.dart';
import 'package:dicoding_restaurant_app/widgets/search_widget.dart';
import 'package:dicoding_restaurant_app/widgets/web_desktop_restaurant_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;

// Future _loadRestaurantData() async {
//   return await rootBundle.loadString('assets/local_restaurant.json');
// }

// Future loadRestaurant() async {
//   String jsonString = await _loadRestaurantData();
//   final jsonResponse = json.decode(jsonString);
//   RestaurantDetail restaurantDetail = RestaurantDetail.fromJson(jsonResponse);
//   return restaurantDetail;
// }

class MainPage extends StatefulWidget {
  static const route = '/main_page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List<RestaurantDetail> restaurantDetail =
  //     loadRestaurant() as List<RestaurantDetail>;
  List<RestaurantDetail> restaurantList = [];
  late List<RestaurantDetail> restaurantSuggestions;
  // String query = '';

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/local_restaurant.json');
    // final data = await json.decode(response);
    final Map<String, dynamic> parsedData = jsonDecode(response);

    setState(() {
      // restaurantList = parsedData['restaurants']
      //     .map((data) => RestaurantDetail.fromJson(data))
      //     .toList();
      List<dynamic> restaurantList = parsedData['restaurants'];
      restaurantList.map((e) => RestaurantDetail.fromJson(e)).toList();
    });
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
                title: Text(
                  "Restaurant",
                ),
                titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              ),
            ),
            SliverAppBar(
                pinned: true,
                backgroundColor: Colors.brown.shade100,
                elevation: 0,
                title: _buildSearchWidget(context))
          ];
        },
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('assets/local_restaurant.json'),
          builder: <String>(context, snapshot) {
            final List<RestaurantDetail> restaurantDetail =
                parseRestaurantDetail(snapshot.data);

            return ListView.builder(
              itemCount: restaurantDetail.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(context, restaurantDetail[index]);
              },
            );
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
            children: [
              Icon(
                Icons.signal_cellular_connected_no_internet_0_bar,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
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

  Widget _buildSearchWidget(BuildContext context) {
    return SearchWidget(
      onChanged: (value) {},
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context, RestaurantDetail restaurantDetail) {
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
      BuildContext context, RestaurantDetail restaurantDetail) {
    return MobileRestaurantListWidget(
      restaurantID: restaurantDetail,
      restaurantName: restaurantDetail,
      restaurantPicture: restaurantDetail,
      restaurantLocation: restaurantDetail,
      restaurantRating: restaurantDetail,
    );
  }

  Widget _webDesktopRestaurantList(
      BuildContext context, RestaurantDetail restaurantDetail) {
    return WebDesktopRestaurantListWidget(
      restaurantID: restaurantDetail,
      restaurantName: restaurantDetail,
      restaurantPicture: restaurantDetail,
      restaurantLocation: restaurantDetail,
      restaurantRating: restaurantDetail,
    );
  }

  void search(String query) {
    final restaurantSuggestions = restaurantList.where((restaurant) {
      final restaurantName = restaurant.name.toLowerCase();
      final restaurantLocation = restaurant.city.toLowerCase();
      final input = query.toLowerCase();

      return restaurantName.contains(input) ||
          restaurantLocation.contains(input);
    }).toList();

    setState(() {
      restaurantList = restaurantSuggestions;
    });
  }

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
    readJson();

    subscription = Connectivity().onConnectivityChanged.listen((event) {});
    // restaurantSuggestions = restaurantList;
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
