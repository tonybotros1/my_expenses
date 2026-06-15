import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsController extends GetxController {
  static const _settingsBoxName = 'settings_box';
  static const _userNameKey = 'user_name';
  static const _currencyKey = 'user_currency';
  static const _isDarkModeKey = 'is_dark_mode';

  final userName = 'Tony B'.obs;
  final currency = 'SYP'.obs;
  final isDarkMode = false.obs;

  Box<dynamic>? _settingsBox;

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadSettings() async {
    final box = await _ensureSettingsBox();
    final savedUserName = box.get(_userNameKey);
    final savedCurrency = box.get(_currencyKey);
    final savedDarkMode = box.get(_isDarkModeKey);

    if (savedUserName is String && savedUserName.trim().isNotEmpty) {
      userName.value = savedUserName;
    }
    if (savedCurrency is String && savedCurrency.trim().isNotEmpty) {
      currency.value = savedCurrency;
    }
    if (savedDarkMode is bool) {
      isDarkMode.value = savedDarkMode;
    }
  }

  Future<void> updateUserName(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    userName.value = trimmed;
    await _saveString(_userNameKey, trimmed);
  }

  Future<void> updateCurrency(String value) async {
    final trimmed = value.trim().toUpperCase();
    if (trimmed.isEmpty) return;
    currency.value = trimmed;
    await _saveString(_currencyKey, trimmed);
  }

  Future<void> setDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
    final box = await _ensureSettingsBox();
    await box.put(_isDarkModeKey, value);
  }

  Future<void> _saveString(String key, String value) async {
    final box = await _ensureSettingsBox();
    await box.put(key, value);
  }

  Future<Box<dynamic>> _ensureSettingsBox() async {
    if (_settingsBox?.isOpen ?? false) {
      return _settingsBox!;
    }

    _settingsBox = Hive.isBoxOpen(_settingsBoxName)
        ? Hive.box<dynamic>(_settingsBoxName)
        : await Hive.openBox<dynamic>(_settingsBoxName);

    return _settingsBox!;
  }
}
