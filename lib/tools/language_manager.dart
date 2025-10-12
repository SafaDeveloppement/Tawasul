import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static const String _languageCodeKey = "language_code";
  static const String _languageIdKey = "language_id";

  // Map your app language codes to API language IDs
  static const Map<String, int> _languageMap = {
    'ar': 1, // Arabic
    'en': 0, // English
  };

  // Get current language ID for API calls
  static Future<int> getCurrentLanguageId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString(_languageCodeKey);
    
    // Default to Arabic if no language set
    return _languageMap[langCode ?? 'ar'] ?? 1;
  }

  // Get current language code
  static Future<String> getCurrentLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey) ?? 'ar';
  }

  // Set language and save both code and ID
  static Future<void> setLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    final String langCode = locale.languageCode;
    final int? langId = _languageMap[langCode];

    if (langId != null) {
      await prefs.setString(_languageCodeKey, langCode);
      await prefs.setInt(_languageIdKey, langId);
    }
  }

  // Get saved language ID directly
  static Future<int> getSavedLanguageId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_languageIdKey) ?? 1; // Default to Arabic
  }

  // Check if current language is Arabic
  static Future<bool> isArabic() async {
    final langCode = await getCurrentLanguageCode();
    return langCode == 'ar';
  }

  // Check if current language is English
  static Future<bool> isEnglish() async {
    final langCode = await getCurrentLanguageCode();
    return langCode == 'en';
  }
}