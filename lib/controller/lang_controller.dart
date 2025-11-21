import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SampleLanguageController extends GetxController {
  // Observable for current language
  final RxString currentLanguage = 'english'.obs;
  
  // Key for SharedPreferences
  static const String _languageKey = 'app_language';

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  // Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'english';
      currentLanguage.value = savedLanguage;
      
      // Update GetX locale
      _updateLocale(savedLanguage);
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  // Change language (both GetX locale and Firebase language)
  Future<void> changeLanguage(String language) async {
    if (currentLanguage.value == language) return;
    
    try {
      // Update observable
      currentLanguage.value = language;
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
      
      // Update GetX locale
      _updateLocale(language);
      
      // Show success message
      Get.snackbar(
        language == 'arabic' ? 'تم التغيير' : 'Changed',
        language == 'arabic' 
            ? 'تم تغيير اللغة إلى العربية' 
            : 'Language changed to English',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5D9C99),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error changing language: $e');
      Get.snackbar(
        'Error',
        'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Update GetX locale
  void _updateLocale(String language) {
    final locale = language == 'arabic' 
        ? const Locale('ar', 'AR') 
        : const Locale('en', 'US');
    Get.updateLocale(locale);
  }

  // Get current language display name
  String get currentLanguageDisplay {
    return currentLanguage.value == 'arabic' ? 'العربية' : 'English';
  }

  // Check if current language is Arabic
  bool get isArabic => currentLanguage.value == 'arabic';
  
  // Check if current language is English
  bool get isEnglish => currentLanguage.value == 'english';
}


