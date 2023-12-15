import 'package:bamboo_chat/utilities/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier
{
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  ThemeProvider(this._mode);

  void toggle(bool value)
  {
    if(value)
      {
        _mode = ThemeMode.dark;
      }
    else
      {
        _mode = ThemeMode.light;
      }
    notifyListeners();
  }
}