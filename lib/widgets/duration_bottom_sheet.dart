import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/activity_bloc/activity_bloc.dart';
import '../widgets/spacer_box.dart';

class DurationBottomSheet extends StatefulWidget {
  final BuildContext context;
  const DurationBottomSheet({Key? key, required this.context}) : super(key: key);

  @override
  State<DurationBottomSheet> createState() => _DurationBottomSheetState();
}

class _DurationBottomSheetState extends State<DurationBottomSheet> {

  //DurationBottomSheet({Key? key, required this.context}) : super(key: key);

  var _daysController = TextEditingController();
  var _hoursController = TextEditingController();
  var _minutesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _daysController.text = '';
    _hoursController.text = '';
    _minutesController.text = '';
  }

  @override
  Widget build(context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState> (
      builder: (context, ActivitiesState state) {
      return SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  const SpacerBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _daysController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.daysShort),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _hoursController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.hoursShort),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _minutesController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.minutesShort),
                    ],
                  ),
                  const SpacerBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Duration duration = Duration(
                            days: int.tryParse(_daysController.text) ?? 0,
                            hours: int.tryParse(_hoursController.text) ?? 0,
                            minutes: int.tryParse(_minutesController.text) ?? 0,
                          );

                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, duration);
                        },
                        child: Text(AppLocalizations.of(context)!.ok),
                      ),
                      const SizedBox(width: 5,),
                      OutlinedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );}
    );
  }
}
