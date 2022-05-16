import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/local/db/database_helper.dart';
import 'package:restaurant_apps/data/local/db/database_provider.dart';
import 'package:restaurant_apps/data/local/preference/preference_helper.dart';
import 'package:restaurant_apps/data/local/preference/preference_provider.dart';
import 'package:restaurant_apps/screens/detail_screen.dart';
import 'package:restaurant_apps/screens/favorite_screen.dart';
import 'package:restaurant_apps/screens/home_screen.dart';
import 'package:restaurant_apps/screens/main_screen.dart';
import 'package:restaurant_apps/screens/search_screen.dart';
import 'package:restaurant_apps/screens/settings_screen.dart';
import 'package:restaurant_apps/styles/styles.dart';
import 'package:restaurant_apps/utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/remote/api_service.dart';
import 'data/remote/provider/restaurant_provider.dart';
import 'notification/background_service.dart';
import 'notification/notification_helper.dart';
import 'notification/scedhuling_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferenceProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: buildMaterialApp(context),
    );
  }

  MaterialApp buildMaterialApp(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: primaryColor,
            onPrimary: Colors.black,
            secondary: secondaryColor),
        textTheme: myTextTheme,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(circularTrackColor: Colors.black),
        appBarTheme: const AppBarTheme(elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: secondaryColor,
            onPrimary: Colors.white,
            textStyle: const TextStyle(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: secondaryColor,
          unselectedItemColor: Colors.grey,
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: MainScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SearchScreen.routeName: (context) => const SearchScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        FavoriteScreen.routeName: (context) => FavoriteScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        DetailScreen.routeName: (context) => DetailScreen(
              id: ModalRoute.of(context)?.settings.arguments as String,
            )
      },
    );
  }
}
