part of 'settings_bloc.dart';

enum Status { normal, error }

class SettingsState extends Equatable {
  final Locale locale;
  final String theme;
  final int fontSize;
  final bool showArchive;
  final Status status;

  const SettingsState({
    this.locale = const Locale('en', ''),
    this.theme = 'Pale',
    this.fontSize = 12,
    this.showArchive = true,
    this.status = Status.normal,
  });

  @override
  List<Object?> get props => [
        locale,
        theme,
        fontSize,
        showArchive,
    status,
      ];

  SettingsState copyWith({
    Locale? locale,
    String? theme,
    int? fontSize,
    bool? showArchive,
    Status? status,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      showArchive: showArchive ?? this.showArchive,
      status: status ?? this.status,
    );
  }

/*  @override
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
      showArchive.hashCode;*/
}

class ErrorSettingsState extends SettingsState {
  @override
  List<Object?> get props => [];
}
