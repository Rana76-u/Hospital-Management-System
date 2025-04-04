import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepo {
  Future<Map<String, List<String>>> loadTypesOfDoctors() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('types of doctors')
        .get();

    Map<String, List<String>> doctorsMap = {};
    for (var doc in snapshot.docs) {
      doctorsMap[doc.id] = List<String>.from(doc.data().values.first);
    }
    return doctorsMap;
  }
}