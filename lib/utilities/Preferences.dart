import 'package:shared_preferences/shared_preferences.dart';

class Preferences
{
  static SharedPreferences? _preferences;

  static void setPrefs(SharedPreferences pref)
  {
    _preferences = pref;
  }

  static SharedPreferences? get getPrefs => _preferences;
}