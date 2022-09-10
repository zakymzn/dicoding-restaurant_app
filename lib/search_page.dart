import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_search.dart';
import 'package:dicoding_restaurant_app/main.dart';
import 'package:dicoding_restaurant_app/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchPage extends StatefulWidget {
  static const route = '/search_page';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  // late Future<RestaurantSearch> _futureRestaurantSearch;
  String? query;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _futureRestaurantSearch = RestaurantAPI().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: "Cari restoran di sini",
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
                  Text("Sedang mencari restoran untuk Anda"),
                ],
              ),
            );
          } else {
            if (snapshot.hasData) {
              if (restaurant!.founded != 0) {
                return ListView.builder(
                  itemCount: restaurant.founded.toInt(),
                  itemBuilder: (context, index) {
                    final restaurantFounded = restaurant.restaurants[index];
                    return SearchResultWidget(
                        restaurantFounded: restaurantFounded);
                  },
                );
              } else if (restaurant.founded == 0) {
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
              } else {
                return Text('data');
              }
            } else if (snapshot.hasError) {
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
                      'Cari restoran yang anda suka',
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
            } else {
              return Center(child: Text(''));
            }
          }
        },
      ),
    );
  }
}
