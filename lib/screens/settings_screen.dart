import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/settings/bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/settings/settings_data.dart';
import 'package:minimal_time_tracker/settings/themes.dart';
import '../widgets/spacer_box.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, SettingsState settingsState) {
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
                    key: Key('languageCodeDropdownButton'),
                    value: settingsState.locale!.languageCode.substring(0, 2),
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
                    key: Key('themeDropdownButton'),
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
                  Text(
                    AppLocalizations.of(context)!.font,
                  ),
                  DropdownButton(
                    key: Key('fontDropdownButton'),
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
                    key: Key('archiveSwitch'),
                    value: settingsState.showArchive!,
                    onChanged: (bool value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeArchiveVisibility(showArchive: value));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

