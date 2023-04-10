part of 'settings_bloc.dart';

class SettingsState {
  Locale? locale;
  String? theme;
  int? fontSize;
  bool? showArchive;

  SettingsState([this.locale, this.theme, this.fontSize, this.showArchive]);

  //переопределено == и hashCode для возможности тестирования
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SettingsState &&
              runtimeType == other.runtimeType &&
              locale == other.locale &&
              theme == other.theme &&
              fontSize == other.fontSize &&
              showArchive == other.showArchive;

  @override
  int get hashCode =>
      locale.hashCode ^
      theme.hashCode ^
      fontSize.hashCode ^
      showArchive.hashCode;
}