import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/profile_page.dart';
import 'package:dicoding_restaurant_app/provider/favorite_button_provider.dart';
import 'package:dicoding_restaurant_app/search_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dicoding_restaurant_app/main_page.dart';
import 'package:dicoding_restaurant_app/detail_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteButtonProvider(),
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
