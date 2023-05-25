import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/activity_bloc/activity_bloc.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../data/settings/settings_data.dart';
import '../data/settings/themes.dart';
import '../widgets/about_app_dialog.dart';
import '../widgets/spacer_box.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, SettingsState settingsState) {
      bool themeModeValue = settingsState.themeMode;

      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                  ),
                  DropdownButton(
                    key: const Key('languageCodeDropdownButton'),
                    value: settingsState.locale.languageCode.substring(0, 2),
                    icon: const Icon(Icons.arrow_downward),
                    items: supportedLocales
                        .map<DropdownMenuItem<String>>((Locale value) {
                      return DropdownMenuItem<String>(
                        value: value.languageCode,
                        child: Text(
                          value.languageCode,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeLanguage(locale: Locale(value!)));
                    },
                  ),
                  const SpacerBox(),
                  Text(
                    AppLocalizations.of(context)!.theme,
                  ),
                  DropdownButton(
                    key: const Key('themeDropdownButton'),
                    value: settingsState.theme,
                    icon: const Icon(Icons.arrow_downward),
                    items: themePalettes.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeTheme(theme: value!));
                    },
                  ),
                  const SpacerBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.light_mode),
                      Switch(
                          value: themeModeValue,
                          onChanged: (bool value) {
                            BlocProvider.of<SettingsBloc>(context)
                                .add(ChangeThemeMode(mode: value));
                          }),
                      const Icon(Icons.dark_mode),
                    ],
                  ),
                  const SpacerBox(),
                  Text(
                    AppLocalizations.of(context)!.font,
                  ),
                  DropdownButton(
                    key: const Key('fontDropdownButton'),
                    value: settingsState.fontSize,
                    icon: const Icon(Icons.arrow_downward),
                    items: fontSizes.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeFontSize(fontSize: value!));
                    },
                  ),
                  const SpacerBox(),
                  Text(AppLocalizations.of(context)!.showArchivedActivities),
                  Switch(
                    key: const Key('archiveSwitch'),
                    value: settingsState.showArchive,
                    onChanged: (bool value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeArchiveVisibility(showArchive: value));
                    },
                  ),
                  const SpacerBox(),
                  OutlinedButton(
                      onPressed: () {
                        _deleteAllDialog(context);
                      },
                      child: Text(AppLocalizations.of(context)!.deleteAll)),
                  const SpacerBox(),
                  const SpacerBox(),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AboutAppDialog(context: context),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.aboutApp),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _deleteAllDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteAllActivities),
          content: Text(AppLocalizations.of(context)!.deleteAllWarning),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel)),
            TextButton(
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context)
                      .add(DeleteAllActivities());
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.deleteAll)),
          ],
        );
      },
    );
  }
}
