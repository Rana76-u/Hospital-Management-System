import 'dart:math';

import 'package:flutter/material.dart';
import '../../../Core/Navigation/AppBar/core_appbar.dart';
import '../../../Core/Navigation/Drawer/core_drawer.dart';
import '../../../Core/Theme/app_color.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: coreAppBar(context, true)
      ),
      drawer: coreDrawer(context),
      backgroundColor: AppColor.backgroundColor,//Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                return Container(color: color, height: 50,);
              },
            ),
          )
        ],
      ),
    );
  }
}
