import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:dicoding_restaurant_app/pages/detail_page.dart';
import 'package:dicoding_restaurant_app/utility/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('restaurant');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var restaurantList = await RestaurantAPI().list();
    var randomRestaurantList =
        Random().nextInt(restaurantList.restaurants.length);
    var randomRestaurant = restaurantList.restaurants[randomRestaurantList];

    var restaurantImage = await _downloadAndSaveFile(
        '${RestaurantAPI().largeImage(randomRestaurant.pictureId)}',
        'restaurantImage');

    var channelId = "1";
    var channelName = "Restaurant Recommendation";
    var channelDescription = "Restaurant Recommendation Channel";

    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(restaurantImage),
      largeIcon: FilePathAndroidBitmap(restaurantImage),
      contentTitle: 'Rekomendasi restoran hari ini',
      htmlFormatContentTitle: true,
      summaryText: '<b>${randomRestaurant.name}</b>',
      htmlFormatSummaryText: true,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      styleInformation: bigPictureStyleInformation,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Ada rekomendasi restoran untukmu',
        'Cek sekarang',
        platformChannelSpecifics,
        payload: json.encode(randomRestaurant.toJson()));

    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantList.fromJson(json.decode(payload));
      var restaurant = data.restaurants[randomRestaurantList];
      Navigation.intentWithData(DetailPage.route, restaurant.id!);
    });
  }
}
