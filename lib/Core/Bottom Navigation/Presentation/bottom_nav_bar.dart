// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../Bloc/bottom_bar_bloc.dart';
import '../Bloc/bottom_bar_events.dart';
import '../Bloc/bottom_bar_state.dart';
import 'bottom_bar_buildbody.dart';

class BottomBar extends StatelessWidget {
   const BottomBar({super.key});

   void checkUserType(BuildContext context) async {
     String userType = await FirebaseFirestore.instance
         .collection('user')
         .doc(FirebaseAuth.instance.currentUser!.uid)
         .get()
         .then((value) => value.data()!['role']);

     BlocProvider.of<BottomBarBloc>(context).add(UpdateUserType(userType));
   }

  @override
  Widget build(BuildContext context) {
     checkUserType(context);
    return BlocProvider(
      create: (_) => BottomBarBloc(),
      child: BlocBuilder<BottomBarBloc, BottomBarState>(
        builder: (context, state) {
          return Scaffold(
            body: bottomBarBuildBody(context, state.index, state.userType),
            bottomNavigationBar: FlashyTabBar(
              animationCurve: Curves.linear,
              selectedIndex: state.index,
              iconSize: 25,
              showElevation: false,
              onItemSelected: (index) async {
                context.read<BottomBarBloc>().add(BottomBarSelectedItem(index));

                await FirebaseFirestore.instance.collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get().then((value) {
                  String userType = value.data()!['role'];
                  print(userType);
                  context.read<BottomBarBloc>().add(UpdateUserType(userType));
                });
                bottomBarBuildBody(context, index, state.userType);
              },
              items: [
                FlashyTabBarItem(
                  icon: const Icon(Icons.home_rounded),
                  title: const Text('Home'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.edit_calendar_rounded),
                  title: const Text('Appointments'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }



}
