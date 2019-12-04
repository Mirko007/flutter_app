import 'dart:async';

import 'package:flutter/material.dart';
import 'AppTranslations.dart';
import 'Application.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {

  const AppTranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguages.contains(locale.languageCode);
    //return ['en', 'hr', 'sl'].contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) async{
    // AppLocalizations class is where the JSON loading actually runs
    AppTranslations localizations = new AppTranslations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}
class AppLocalizations {

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppTranslations> delegate =
  AppTranslationsDelegate();

}