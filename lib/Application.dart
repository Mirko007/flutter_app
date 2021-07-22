import 'dart:ui';

class Application {

  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();


  //todo dvije verzija aplikacije, ako je hrvatska verzija aplikacije onda hr i en, hr default (hr_hr)
  //- SLOVENSKA verzija - default je sl nekako, eng radi ,slovenija sl_SI
  // Za slovensku verziju HR json prebaciti na slovenski
  final List<String> supportedLanguages = [
    "hr",
    "en",
    "en",
    "en",
    "si",
    "sl",
    "sl"
  ];

  final List<String> supportedLanguagesCodes = [
    "hr",
    "en",
    "US",
    "UK",
    "SL",
    "SL",
    "SI"
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language,""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);