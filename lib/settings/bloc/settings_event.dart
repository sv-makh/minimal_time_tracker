part of 'settings_bloc.dart';

class SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  Locale locale;

  ChangeLanguage({required this.locale});
}

class SetInitialSetting extends SettingsEvent {
  BuildContext context;

  SetInitialSetting({required this.context});
}

class ChangeThemeMode extends SettingsEvent {
  bool mode;

  ChangeThemeMode({required this.mode});
}

class ChangeTheme extends SettingsEvent {
  String theme;

  ChangeTheme({required this.theme});
}

class ChangeFontSize extends SettingsEvent {
  int fontSize;

  ChangeFontSize({required this.fontSize});
}

class ChangeArchiveVisibility extends SettingsEvent {
  bool showArchive;

  ChangeArchiveVisibility({required this.showArchive});
}