// Flutter imports:
import 'package:caresync_hms/Core/Navigation/Routing/routing.dart';
import 'package:caresync_hms/Core/Snackbar/custom_snackbars.dart';
import 'package:caresync_hms/Core/Theme/app_color.dart';
import 'package:caresync_hms/Screens%20&%20Features/User/Auth/Presentation/Signup/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:

// Project imports:
import '../../../../../Core/Bottom Navigation/Bloc/bottom_bar_bloc.dart';
import '../../../../../Core/Bottom Navigation/Bloc/bottom_bar_events.dart';
import '../../../../../Core/Bottom Navigation/Presentation/bottom_nav_bar.dart';
import '../../../../../DesignPatterns/DecoratorProfile/decorator_profile.dart';
import '../../../../../DesignPatterns/SingletonAuthentication/singleton_auth.dart';
import 'login_widgeds.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final authService = AuthService.instance;

  void loginOnPressFunctions() {
    setState(() {
      isLoading = true;
    });

    AuthService.instance.signInWithGoogle().then((_) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        CustomSnackBar().openErrorSnackBar(context, "User is null after sign-in.");
        return;
      }

      bool isUserExists = await UserRepository().checkUserExists(user.uid);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (isUserExists) {
        CustomSnackBar().openIconSnackBar(
          context,
          'Login Successful',
          Icon(Icons.done, color: Colors.white),
        );
        //send to HomePage
        await FirebaseFirestore.instance.collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get().then((value) {
          String userType = value.data()!['role'];
          context.read<BottomBarBloc>().add(UpdateUserType(userType));
        });

        Routing().goto(context, BottomBar());
      } else {
        Routing().goto(context, SignupPage());
      }
    }).catchError((error) {
      if (!mounted) return;

      CustomSnackBar().openErrorSnackBar(context, error.toString());

      debugPrint('Login Error: $error');

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
