import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const DAILY_NOTIF = 'DAILY_NOTIF';

  Future<bool> get isDailyNotifActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_NOTIF) ?? false;
  }

  void setDailyNotif(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_NOTIF, value);
  }
}