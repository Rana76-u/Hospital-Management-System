import 'package:caresync_hms/Core/Titles/title_n_seeall.dart';
import 'package:flutter/material.dart';
import 'package:caresync_hms/Core/Snackbar/custom_snackbars.dart';
import 'package:caresync_hms/Screens%20&%20Features/Homepage/Repository/home_repo.dart';

Widget typesOfDoctors() {
  return Column(
    children: [
      titleAndSeeAllWidget('Explore by Types'),
      typesOfDoctorLoaderWidget(),
    ],
  );
}



Widget typesOfDoctorLoaderWidget() {
  return FutureBuilder(
    future: HomeRepo().loadTypesOfDoctors(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return CustomSnackBar().openErrorSnackBar(context, snapshot.error.toString());
      } else {
        final doctorsMap = snapshot.data as Map<String, List<String>>;

        List selectedItems = [];
        for(int i=0; i<doctorsMap.length; i++){
          selectedItems.add(doctorsMap.entries.elementAt(i).value[1]);
        }

        return Wrap(
          spacing: 1, // Space between cards
          runSpacing: 1, // Space between lines
          children: List.generate(
              selectedItems.length,
                  (i) {
                return CategoryCard(
                  title: selectedItems[i],
                );
              }),
        );
      }
    },
  );
}

class CategoryCard extends StatelessWidget {
  final String title;

  const CategoryCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: Colors.blueGrey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(title, style: TextStyle(fontSize: 12.0)),
      ),
    );
  }
}