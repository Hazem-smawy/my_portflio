import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  /// Observables
  var isDark = true.obs;
  var currentColor = Colors.blue.obs;

  /// Toggle between dark and light mode
  void toggleTheme() {
    isDark.value = !isDark.value;
  }

  /// Change primary color
  void setColor(MaterialColor color) {
    currentColor.value = color;
  }

  /// Get ThemeMode
  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;
}
