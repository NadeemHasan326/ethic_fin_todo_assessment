import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppDurations {
  AppDurations._();

  static const Duration press = Duration(milliseconds: 90);
  static const Duration cardPress = Duration(milliseconds: 120);
  static const Duration chip = Duration(milliseconds: 180);
  static const Duration fabIcon = Duration(milliseconds: 180);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration standard = Duration(milliseconds: 280);
  static const Duration banner = Duration(milliseconds: 300);
  static const Duration iconPop = Duration(milliseconds: 320);
  static const Duration appear = Duration(milliseconds: 380);
  static const Duration page = Duration(milliseconds: 380);
  static const Duration pageReverse = Duration(milliseconds: 280);
  static const Duration toastIn = Duration(milliseconds: 420);
  static const Duration splashFade = Duration(milliseconds: 500);
  static const Duration fabIntro = Duration(milliseconds: 520);
  static const Duration splashIntro = Duration(milliseconds: 900);
  static const Duration splashPulse = Duration(milliseconds: 1400);
  static const Duration splashHold = Duration(milliseconds: 1800);
  static const Duration toastHold = Duration(milliseconds: 2800);
  static const Duration firestoreTimeout = Duration(seconds: 15);
  static const Duration defaultDueIn = Duration(days: 1);
  static const Duration datePickerPast = Duration(days: 365);
  static const Duration datePickerFuture = Duration(days: 365 * 5);

  static const int appearStaggerStepMs = 40;
  static const int appearStaggerMaxMs = 200;
}

class AppMotion {
  AppMotion._();

  static const Offset pageSlideBegin = Offset(0.06, 0);
  static const Offset appearSlideBegin = Offset(0, 0.08);
  static const Offset splashSlideBegin = Offset(0, 0.12);
  static const double appearScaleBegin = 0.92;
  static const double splashScaleBegin = 0.86;
  static const double cardPressScale = 0.98;
  static const double fabPressScale = 0.92;
  static const double fabIntroTurns = -0.25;
  static const double fabPressTurns = 0.125;
  static const double completeIconScaleBegin = 0.72;
  static const double toggleButtonScaleBegin = 0.96;
  static const double themeIconTurnsBegin = 0.75;
  static const double fullTurnRadians = math.pi * 2;
}
