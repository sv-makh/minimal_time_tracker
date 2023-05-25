part of 'settings_bloc.dart';

enum Status { normal, error }

class SettingsState extends Equatable {
  final Locale locale;
  final String theme;
  final int fontSize;
  final bool showArchive;
  final Status status;
  final bool themeMode;

  const SettingsState({
    this.locale = const Locale('en', ''),
    this.theme = 'Pale',
    this.fontSize = 12,
    this.showArchive = true,
    this.themeMode = true,
    this.status = Status.normal,
  });

  @override
  List<Object?> get props => [
        locale,
        theme,
        fontSize,
        showArchive,
        themeMode,
        status,
      ];

  SettingsState copyWith({
    Locale? locale,
    String? theme,
    int? fontSize,
    bool? showArchive,
    bool? themeMode,
    Status? status,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      showArchive: showArchive ?? this.showArchive,
      themeMode: themeMode ?? this.themeMode,
      status: status ?? this.status,
    );
  }
}
