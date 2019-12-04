import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  final Locale locale;
  static Map<String, String> _localizedStrings;

  AppTranslations(this.locale);


  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
    await rootBundle.loadString("assets/locale/localization_${locale.languageCode}.json");
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }


  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localizedStrings[key] ?? "$key not found";
  }
}