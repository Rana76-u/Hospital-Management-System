import 'dart:ui';
import 'package:caresync_hms/Core/Theme/theme.dart';

class AppColor {
  static var primaryColorTeal = Color(0xFF00897B);
  static const primaryColorBlue = Color(0xFF01579B);

  static const secondaryColorSoftGreen = Color(0xFF4CAF50);
  static const secondaryColorLightGray = Color(0xFFF5F5F5);

  static const accentColorOrange = Color(0xFFFF9800);

  static var backgroundColor = AppTheme().isDark ? Color(0xFF424242) : Color(0xFFF5F5F5);

  static var errorColor = Color(0xffEF4444);
}