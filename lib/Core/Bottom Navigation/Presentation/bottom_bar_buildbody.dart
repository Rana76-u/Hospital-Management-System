// Flutter imports:
import 'package:caresync_hms/Screens%20&%20Features/Homepage/Presentation/home.dart';
import 'package:flutter/material.dart';
import '../../../Screens & Features/User/Profile/Presentation/profile.dart';

// Project imports:

Widget bottomBarBuildBody(BuildContext context, int index) {
  switch (index) {
    case 0:
      return const HomePage();
    case 1:
      return const Placeholder();
    case 2:
      return ProfileScreen();
    default:
      return const SizedBox();
  }
}
