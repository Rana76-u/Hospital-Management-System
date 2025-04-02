import 'package:caresync_hms/Core/Bottom%20Navigation/Bloc/bottom_bar_bloc.dart';
import 'package:caresync_hms/Core/Bottom%20Navigation/Presentation/bottom_nav_bar.dart';
import 'package:caresync_hms/Core/Theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens & Features/User/Auth/Presentation/Login/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BottomBarBloc(),)
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColorBlue),
          ),
          debugShowCheckedModeBanner: false,
          home: FirebaseAuth.instance.currentUser != null ? BottomBar() : LoginPage(),
        )
    );
  }
}
