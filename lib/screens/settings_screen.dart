import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/data/language_bloc.dart';
import 'package:minimal_time_tracker/themes/settings_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, LanguageState state) {
        String currentLangCode = state.locale.languageCode;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settings),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.language),
                    //DropdownButton(items: items, onChanged: onChanged)
                    Text(AppLocalizations.of(context)!.theme),
                    Text(AppLocalizations.of(context)!.font),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
