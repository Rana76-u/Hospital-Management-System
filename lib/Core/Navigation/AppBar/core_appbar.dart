import 'package:caresync_hms/Core/Bottom%20Navigation/Bloc/bottom_bar_bloc.dart';
import 'package:caresync_hms/Core/Bottom%20Navigation/Bloc/bottom_bar_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../DesignPatterns/SingletonAuthentication/singleton_auth.dart';
import '../../../Screens & Features/User/Auth/Presentation/Login/login.dart';


Widget coreAppBar(BuildContext context, bool automaticImplyLeading) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: automaticImplyLeading,
    title: SizedBox(
      height: 150,
      child: Image.asset('assets/logo.png'),
    ),
    actions:  [
      Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: SizedBox(
            height: 45,
            width: 45,
            child: _ProfileIcon()
        ),
      )
    ],
  );
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(FirebaseAuth.instance.currentUser!.photoURL.toString())),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: Text('Account'),
            onTap: () {
              BlocProvider.of<BottomBarBloc>(context).add(BottomBarSelectedItem(2));
            },
          ),
          PopupMenuItem(
            child: Text('Sign Out'),
            onTap: () {
              AuthService.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ]);
  }
}
