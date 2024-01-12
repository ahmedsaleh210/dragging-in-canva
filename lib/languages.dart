import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_project/main.dart';

enum Languages {
  english(Locale('en', 'US'), 'English'),
  arabic(Locale('ar', 'EG'), 'Arabic');

  final String title;
  final Locale locale;

  const Languages(this.locale, this.title);

  static List<Locale> get suppoerLocales => const [
        Locale('en', 'US'),
        Locale('ar', 'EG'),
      ];

  static List<String> get titles =>
      Languages.values.map((e) => e.title).toList();

  static setLocale(Languages lang) {
    MyApp.navigatorKey.currentContext!.setLocale(lang.locale);
  }

}

