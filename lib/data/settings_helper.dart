import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHelper {
  static final SettingsHelper instance = SettingsHelper._init();
  SettingsHelper._init();

  SharedPreferences? _sharedPrefs;

  Future<SharedPreferences> get _prefs async {
    if (_sharedPrefs == null) {
      WidgetsFlutterBinding.ensureInitialized();
      _sharedPrefs = await SharedPreferences.getInstance();
    }
    return _sharedPrefs!;
  }

  Future<void> setPreferOriginalUnit(bool value) async {
    await (await _prefs).setBool("preferOriginalUnit", value);
  }

  Future<bool> getPreferOriginalUnit() async {
    return (await _prefs).getBool("preferOriginalUnit") ?? false;
  }
}
