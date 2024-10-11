import 'package:flutter/material.dart';
import 'package:todo/localization/localization_keys.dart';
import 'package:todo/utils/app_localization_class.dart';

class NothingWidget extends StatelessWidget {
  const NothingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(LocalizationKeys.noThingToDo.tr(context)),
    );
  }
}
