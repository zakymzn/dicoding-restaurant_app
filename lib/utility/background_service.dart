import 'dart:ui';
import 'dart:isolate';
import 'package:dicoding_restaurant_app/main.dart';
import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/utility/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    print('Notification coming');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await RestaurantAPI().list();
  }
}
