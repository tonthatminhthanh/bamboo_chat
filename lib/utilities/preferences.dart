import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences
{
  static SharedPreferences? _preferences;

  static void setPrefs(SharedPreferences pref)
  {
    _preferences = pref;
  }

  static SharedPreferences? get getPrefs => _preferences;

  static void setBool(bool value)
  {
    _preferences!.setBool("isDark", value);
  }

  static bool getBool()
  {
    return _preferences!.getBool("isDark")!;
  }
}