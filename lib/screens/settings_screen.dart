import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';
import 'package:minimal_time_tracker/settings/settings_data.dart';
import 'package:minimal_time_tracker/settings/themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, SettingsState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.language),
                  DropdownButton(
                    value: state.locale!.languageCode,
                    icon: const Icon(Icons.arrow_downward),
                    items: supportedLocales
                        .map<DropdownMenuItem<String>>((Locale value) {
                      return DropdownMenuItem<String>(
                        value: value.languageCode,
                        child: Text(value.languageCode),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeLanguage(locale: Locale(value!)));
                    },
                  ),
                  Text(AppLocalizations.of(context)!.theme),
                  DropdownButton(
                    value: state.theme,
                    icon: const Icon(Icons.arrow_downward),
                    items: themeData.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeTheme(theme: value!));
                    },
                  ),
                  Text(AppLocalizations.of(context)!.font),
                  DropdownButton(
                    value: state.fontSize,
                    icon: const Icon(Icons.arrow_downward),
                    items:
                        fontSizes.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(ChangeFontSize(fontSize: value));
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
