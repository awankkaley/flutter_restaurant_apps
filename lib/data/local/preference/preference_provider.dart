import 'package:flutter/cupertino.dart';
import 'package:restaurant_apps/data/local/preference/preference_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferenceProvider({required this.preferencesHelper}) {
    _getDailyNotifPreferences();
  }

  bool _isDailyNotifActive = false;

  bool get isDailyNotifActive => _isDailyNotifActive;

  void _getDailyNotifPreferences() async {
    _isDailyNotifActive = await preferencesHelper.isDailyNotifActive;
    notifyListeners();
  }

  void enableDailyNotif(bool value) {
    preferencesHelper.setDailyNotif(value);
    _getDailyNotifPreferences();
  }
}
