import 'package:caresync_hms/Screens%20&%20Features/Homepage/Presentation/Widgets/show_doctor_column.dart';
import 'package:caresync_hms/Screens%20&%20Features/Homepage/Presentation/Widgets/show_doctor_profiles.dart';
import 'package:caresync_hms/Screens%20&%20Features/Homepage/Presentation/Widgets/types_of_doctors_widget.dart';
import 'package:flutter/material.dart';
import '../../../Core/Navigation/AppBar/core_appbar.dart';
import '../../../Core/Navigation/Drawer/core_drawer.dart';
import '../../../Core/Theme/app_color.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: coreAppBar(context, true)
      ),
      drawer: coreDrawer(context),
      backgroundColor: AppColor.backgroundColor,//Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              showDoctorProfileSlider(),
              const SizedBox(height: 20),
              typesOfDoctors(),
              const SizedBox(height: 20),
              showDoctorProfileColumn(),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
