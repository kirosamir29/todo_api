import 'package:flutter/material.dart';

bool isPortraitMode(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}

bool isLandscapeMode(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}
