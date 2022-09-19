import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/pages/profile_page.dart';
import 'package:dicoding_restaurant_app/providers/favorite_button_provider.dart';
import 'package:dicoding_restaurant_app/pages/search_page.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/providers/restaurant_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dicoding_restaurant_app/pages/main_page.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteButtonProvider>(
          create: (context) => FavoriteButtonProvider(),
        ),
        ChangeNotifierProvider<RestaurantListProvider>(
          create: (context) => RestaurantListProvider(
            restaurantAPI: RestaurantAPI(),
          ),
        ),
        ChangeNotifierProvider<RestaurantSearchProvider>(
          create: (context) => RestaurantSearchProvider(
            restaurantAPI: RestaurantAPI(),
          ),
        ),
      ],
      child: MaterialApp(
        title: "Restaurant App",
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Colors.brown.shade100,
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.notoSans(),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: MainPage.route,
        routes: {
          MainPage.route: (context) => const MainPage(),
          DetailPage.route: (context) => DetailPage(
                id: ModalRoute.of(context)?.settings.arguments as String,
              ),
          SearchPage.route: (context) => const SearchPage(),
          ProfilePage.route: (context) => const ProfilePage(),
        },
      ),
    );
  }
}
