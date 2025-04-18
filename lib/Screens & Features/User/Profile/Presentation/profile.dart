import 'package:caresync_hms/Core/Snackbar/custom_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../DesignPatterns/DecoratorProfile/decorator_profile.dart';
import '../Controller/profile_controller.dart';
import 'Widgets/profile_input_field.dart';
import 'Widgets/profile_photo.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileControllers controllers = ProfileControllers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveProfile,
        icon: Icon(Icons.save),
        label: Text("Save"),
      ),
      appBar: AppBar(title: Text("Profile"), automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            profilePhoto(),
            SizedBox(height: 10),
            ProfileInputFields(controllers: controllers),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;


    try {
      await UserRepository.updateUserProfile(userId, controllers);
      if(!mounted) return;
      CustomSnackBar().openPrimarySnackBar(context, "Profile Updated Successfully");
    } catch (error) {
      CustomSnackBar().openErrorSnackBar(context, "Failed to Update Profile: $error");
    }
  }
}
