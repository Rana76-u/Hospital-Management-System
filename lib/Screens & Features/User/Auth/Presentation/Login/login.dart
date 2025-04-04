// Flutter imports:
import 'package:caresync_hms/Core/Navigation/Routing/routing.dart';
import 'package:caresync_hms/Core/Snackbar/custom_snackbars.dart';
import 'package:caresync_hms/Core/Theme/app_color.dart';
import 'package:caresync_hms/Screens%20&%20Features/User/Auth/Presentation/Signup/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import '../../../../../Core/Bottom Navigation/Presentation/bottom_nav_bar.dart';
import '../../../user_data.dart';
import '../../Data/auth_service.dart';
import 'login_widgeds.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  void loginOnPressFunctions() {

    setState(() {isLoading = true;});

    AuthService().signInWithGoogle().then((_) async {

      bool isUserExists = await UserRepository().checkUserExists(FirebaseAuth.instance.currentUser!.uid);
      if(!mounted) return;

      setState(() {
        isLoading = false;
      });

      if(isUserExists){
        CustomSnackBar().openIconSnackBar(context, 'Login Successful', Icon(Icons.done, color: Colors.white,));
        Routing().goto(context, BottomBar());
      }
      else{
        Routing().goto(context, SignupPage());
      }

    })
        .catchError((error) {
      if(!mounted) return;
      CustomSnackBar().openErrorSnackBar(context, error);

      debugPrint('Error: $error');

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LoginWidgets().topTexts(),

            //Login Button
            isLoading ?
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const LinearProgressIndicator(),
            )
                :
            LoginWidgets().loginButton(context, loginOnPressFunctions)
          ],
        ),
      ),
    );
  }
}
