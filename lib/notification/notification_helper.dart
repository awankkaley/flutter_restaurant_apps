
import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_apps/models/restaurants.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/navigation.dart';

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
    const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            print('notification payload: ' + payload);
          }
          selectNotificationSubject.add(payload ?? 'empty payload');
        });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantResult restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var random = new Random();
    var randomInt = random.nextInt(restaurant.restaurants.length);

    var titleNotification = "Recomendation restaurant for you";
    var titleResto = "<b>"+restaurant.restaurants[randomInt].name+"</b>";

    await flutterLocalNotificationsPlugin.show(
        0, titleResto, titleNotification, platformChannelSpecifics,
        payload: json.encode(restaurant.restaurants[randomInt].toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
          (String payload) async {
        var data = Restaurant.fromJson(json.decode(payload));
        var article = data.id;
        Navigation.intentWithData(route, article);
      },
    );
  }
}