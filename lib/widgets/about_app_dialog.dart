import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../widgets/spacer_box.dart';

class AboutAppDialog extends StatefulWidget {
  final BuildContext context;

  const AboutAppDialog({Key? key, required this.context}) : super(key: key);

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();
    packageInfo.then((value) {
      setState(() {
        appVersion = value.version;
      });
    });
  }

  @override
  Widget build(context) {

    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, SettingsState settingsState) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.aboutApp),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SpacerBox(),
              Text(
                AppLocalizations.of(context)!.author,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _launchUrl('https://github.com/sv-makh'),
                child: Text(
                  'sv-makh',
                  style: TextStyle(fontSize: settingsState.fontSize.toDouble()),
                ),
              ),
              const SpacerBox(),
              Text(
                AppLocalizations.of(context)!.version,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(appVersion),
              const SpacerBox(),
              Text(
                AppLocalizations.of(context)!.source,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _launchUrl(
                    'https://github.com/sv-makh/minimal_time_tracker'),
                child: Text('github',
                    style:
                        TextStyle(fontSize: settingsState.fontSize.toDouble())),
              ),
              const SpacerBox(),
              Text(
                AppLocalizations.of(context)!.license,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () =>
                    _launchUrl('https://en.wikipedia.org/wiki/MIT_License'),
                child: Text('MIT',
                    style:
                        TextStyle(fontSize: settingsState.fontSize.toDouble())),
              ),
              const SpacerBox(),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      );
    });
  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw Exception('Could not launch $url');
  }
}
