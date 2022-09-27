import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    var randomRestaurant = restaurantList
        .restaurants[Random().nextInt(restaurantList.restaurants.length)];

    var restaurantImage = await _downloadAndSaveFile(
        '${RestaurantAPI().largeImage(randomRestaurant.pictureId)}',
        'restaurantImage');

    var channelId = "1";
    var channelName = "Restaurant Recommendation";
    var channelDescription = "Restaurant Recommendation Channel";

    const notificationSound = 'restaurant_notification.mp3';

    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(restaurantImage),
      largeIcon: FilePathAndroidBitmap(restaurantImage),
      contentTitle: 'Rekomendasi restoran hari ini',
      htmlFormatContentTitle: true,
      summaryText:
          '<b>${randomRestaurant.name}</b>, berlokasi di ${randomRestaurant.city}',
      htmlFormatSummaryText: true,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      visibility: NotificationVisibility.public,
      sound: RawResourceAndroidNotificationSound(
          notificationSound.split('.').first),
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
      payload: json.encode(
        restaurantList.toJson(),
      ),
    );
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantList.fromJson(json.decode(payload));
      var restaurant =
          data.restaurants[Random().nextInt(data.restaurants.length)];
      Navigator.pushNamed(context, route, arguments: restaurant.id);
    });
  }
}
