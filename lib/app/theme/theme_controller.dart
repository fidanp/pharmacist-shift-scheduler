import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs; // Observable boolean

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
