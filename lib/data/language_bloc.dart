import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  Locale locale;

  ChangeLanguage({required this.locale});
}

class SetInitialLocale extends LanguageEvent {
}

class LanguageState {
  Locale locale;

  LanguageState(this.locale);
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {

  LanguageBloc() : super(LanguageState(Locale('en', ''))) {

    on<SetInitialLocale>((SetInitialLocale event, Emitter<LanguageState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String langCode = prefs.getString('lang') ?? Platform.localeName;
      Locale initLocale = Locale(langCode);

      return emitter(LanguageState(initLocale));
    });

    on<ChangeLanguage>((ChangeLanguage event, Emitter<LanguageState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Locale newLocale = event.locale;
      prefs.setString('lang', newLocale.languageCode);//then Проверка
      
      return emitter(LanguageState(newLocale));
    });
  }
}
