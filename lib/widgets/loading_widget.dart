import 'package:flutter/material.dart';
import 'package:todo/localization/localization_keys.dart';
import 'package:todo/utils/app_localization.dart';
import 'package:todo/widgets/circular_indicator_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.5),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey,
          ),
          height: MediaQuery.of(context).size.height * .2,
          width: MediaQuery.of(context).size.width * .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocalizationKeys.pleaseWait.tr(context),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 16,
              ),
              const CircularIndicatorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
