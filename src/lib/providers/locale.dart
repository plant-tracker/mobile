import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleService {
  final List<Locale> supportedLocales = [
    const Locale('en'),
  ];

  final Iterable<LocalizationsDelegate<dynamic>>? delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

final localeProvider = Provider<LocaleService>((ref) {
  return LocaleService();
});
