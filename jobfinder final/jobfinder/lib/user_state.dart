import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:jobfinder/screens/home/home_screen.dart';
import 'package:jobfinder/screens/jobs/jobs_screen.dart';
//import 'package:jobfinder/screens/login/login_screen.dart';
import 'package:jobfinder/screens/welcome/welcome_Screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.data == null) {
          print('user is not logged in yet');
          //return Login();
          return WelcomeScreen();
        } else if (userSnapshot.data != null) {
          print("user is already logged in");
          return JobScreen();
          //return Homescreen();
        } else if (userSnapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error has been occured. Try again later'),
            ),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}
