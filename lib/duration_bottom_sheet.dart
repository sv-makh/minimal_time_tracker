import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/activity_bloc.dart';

class DurationBottomSheet extends StatefulWidget {
  final BuildContext context;
  const DurationBottomSheet({Key? key, required this.context}) : super(key: key);

  @override
  State<DurationBottomSheet> createState() => _DurationBottomSheetState();
}

// class _DurationBottomSheetState extends State<DurationBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


class _DurationBottomSheetState extends State<DurationBottomSheet> {
  //BuildContext context;

  //DurationBottomSheet({Key? key, required this.context}) : super(key: key);

  var _daysController = TextEditingController();
  var _hoursController = TextEditingController();
  var _minutesController = TextEditingController();

  @override
  Widget build(context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState> (
      builder: (context, ActivitiesState state) {
      return SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        child: TextField(
                          controller: _daysController,
                          //inputFormatters: [
                          //  FilteringTextInputFormatter.digitsOnly
                          //],
                          //keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.daysShort),
                      Container(
                        width: 50,
                        child: TextField(
                          controller: _hoursController,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                          // keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.hoursShort),
                      Container(
                        width: 50,
                        child: TextField(
                          controller: _minutesController,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                          // keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.minutesShort),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          //нужны начальные знчения и проверка на 0
                          Duration duration = Duration(
                            days: int.tryParse(_daysController.text) ?? 1,
                            hours: int.tryParse(_hoursController.text) ?? 1,
                            minutes: int.tryParse(_minutesController.text) ?? 1,
                          );

                          BlocProvider.of<ActivitiesBloc>(context).add(AddedDurationButton(duration: duration));
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(AppLocalizations.of(context)!.ok),
                      ),
                      SizedBox(width: 5,),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
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
