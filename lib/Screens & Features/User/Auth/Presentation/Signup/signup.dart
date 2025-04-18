import 'package:caresync_hms/Core/Bottom%20Navigation/Presentation/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Navigation/Routing/routing.dart';
import '../../../../../Core/Snackbar/custom_snackbars.dart';
import '../../../../../DesignPatterns/DecoratorProfile/decorator_profile.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  List<bool> _isSelected = List.generate(4, (index) => false,);

  String userType = '';

  void userTypeGenerator() {
    int index = -1;
    for(int i=0; i<_isSelected.length; i++){
      if(_isSelected[i] == true){
        index = i;
      }
    }

    switch(index){
      case 0: setState(() {userType = 'doctor';});
      case 1: setState(() {userType = 'patient';});
      case 2: setState(() {userType = 'staff';});
      case 3: setState(() {userType = 'admin';});
      default: '';
    }
  }

  void checkAndCreateUser() {
    //determine the userType based on the selection
    userTypeGenerator();
    //if user type is determined then
    if(userType != ''){
      //save the initial values for new users in Database
      UserRepository().createNewUser(userType);
      //Just for context issue
      if(!mounted) return;
      //show welcome message
      CustomSnackBar().openIconSnackBar(
          context,
          'Welcome, ${FirebaseAuth.instance.currentUser!.displayName}',
          Icon(Icons.done, color: Colors.white,
          )
      );
      //send to HomePage
      Routing().goto(context, BottomBar());
    }
    else{
      //show warning message
      CustomSnackBar().openWarningSnackBar(context, 'Please Select Any One To Proceed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            signUpText(),

            toggleSelectionWidget(),
          ],
        ),
      ),
    );
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        checkAndCreateUser();
      },
      heroTag: 'Signup Fab',
      shape: const CircleBorder(),
      child: Icon(Icons.arrow_circle_right),
    );
  }

  Widget signUpText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'Signup As . . .',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22
        ),
      ),
    );
  }

  Widget toggleSelectionWidget() {
    return SizedBox(
      width: double.infinity,
      child: ToggleButtons(
        isSelected: _isSelected,
        onPressed: (index) {
          setState(() {
            _isSelected = List.generate(4, (index) => false,);
            _isSelected[index] = true;
          });
        },
        borderRadius: BorderRadius.circular(15),
        direction: Axis.vertical,
        children: [
          Text('Doctor'),
          Text('Patient'),
          Text('Staff'),
          Text('Admin'),
        ],
      ),
    );
  }
}
