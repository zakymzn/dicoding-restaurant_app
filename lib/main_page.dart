import 'package:dicoding_restaurant_app/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/data/restaurant.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

Future _loadRestaurantData() async {
  return await rootBundle.loadString('assets/local_restaurant.json');
}

Future loadRestaurant() async {
  String jsonString = await _loadRestaurantData();
  final jsonResponse = json.decode(jsonString);
  RestaurantDetail restaurantDetail = RestaurantDetail.fromJson(jsonResponse);
  return restaurantDetail;
}

class MainPage extends StatefulWidget {
  static const route = '/main_page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  // late List<RestaurantDetail> restaurantDetail;
  late List<RestaurantDetail> restaurantSuggestions;
  String query = '';

  // @override
  // void initState() {
  //   super.initState();
  //   textEditingController;

  //   restaurantSuggestions = restaurantDetail;
  // }

  @override
  Widget build(BuildContext context) {
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
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.brown.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Cari restoran',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: search,
                  ),
                ),
              ),
            )
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
    return SizedBox(
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: restaurantDetail.id,
                      child: Image(
                        image: NetworkImage(restaurantDetail.pictureId),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantDetail.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.place,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            restaurantDetail.city,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          Text(restaurantDetail.rating.toString()),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _webDesktopRestaurantList(
      BuildContext context, RestaurantDetail restaurantDetail) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 5),
      child: SizedBox(
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: restaurantDetail.id,
                        child: Image(
                          image: NetworkImage(restaurantDetail.pictureId),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantDetail.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.place,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              restaurantDetail.city,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            Text(restaurantDetail.rating.toString()),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void search(String query) {
    final List<RestaurantDetail> restaurantDetail = parseRestaurantDetail(json);
    final restaurantSuggestions = restaurantDetail.where((restaurant) {
      final restaurantName = restaurant.name.toLowerCase();
      final restaurantLocation = restaurant.city.toLowerCase();
      final input = query.toLowerCase();

      return restaurantName.contains(input) ||
          restaurantLocation.contains(input);
    }).toList();

    setState(() {
      this.query = query;
      this.restaurantSuggestions = restaurantSuggestions;
    });
  }

  Route _createSlideTransition(Widget pageTarget, dx, dy, int milliseconds) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => pageTarget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(dx, dy);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: milliseconds),
    );
  }
}
