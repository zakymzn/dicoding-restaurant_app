import 'package:dicoding_restaurant_app/data/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantList restaurantList) async {
    var channelId = restaurantList.restaurants.map((e) => e.id).toString();
    var channelName = restaurantList.restaurants.map((e) => e.name).toString();
    var channelDescription =
        restaurantList.restaurants.map((e) => e.description).toString();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
  }
}
