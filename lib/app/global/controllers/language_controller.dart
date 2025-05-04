import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  // Reactive variable to track the selected language
  var selectedLanguage = 'en'.obs;

  void selectLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    // Update the app's locale here
    Get.updateLocale(Locale(languageCode.toLowerCase()));
  }
}