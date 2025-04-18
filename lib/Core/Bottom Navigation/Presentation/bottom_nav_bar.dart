// Flutter imports:
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomBarBloc(),
      child: BlocBuilder<BottomBarBloc, BottomBarState>(
        builder: (context, state) {
          return Scaffold(
            body: bottomBarBuildBody(context, state.index),
            bottomNavigationBar: FlashyTabBar(
              animationCurve: Curves.linear,
              selectedIndex: state.index,
              iconSize: 25,
              showElevation: false,
              onItemSelected: (index) {
                context.read<BottomBarBloc>().add(BottomBarSelectedItem(index));
                bottomBarBuildBody(context, index);
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
