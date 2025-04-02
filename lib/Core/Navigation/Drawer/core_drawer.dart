import 'package:flutter/material.dart';
import 'drawer_header.dart';

Widget coreDrawer(BuildContext context){
  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0)),
    ),
    child: ListView(
      children: [
        drawerHeader(context),

        drawerItems(context),
      ],
    ),
  );
}

List categories = ['Appointment', 'Profile', 'History'];

Widget drawerItems(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      String categoryName = categories[index];
      return ExpansionTile(
        title: Text(
            categoryName,
            style: const TextStyle(
                fontWeight: FontWeight.bold
            )
        ),
      );
    },
  );
}
