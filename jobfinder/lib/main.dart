import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:jobfinder/screens/login/login_screen.dart';
//import 'package:jobfinder/screens/welcome/welcome_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:jobfinder/screens/home/home_screen.dart';
import 'package:jobfinder/screens/welcome/welcome_Screen.dart';
import 'package:jobfinder/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBkFMBt51pvYl7VZ05-Y-nhjJcMgDrPZwU',
      appId: '1:885243590521:android:3f6860c440679fb1d021a8',
      messagingSenderId: '885243590521',
      projectId: 'jobfinder-8ceb9',
      authDomain: 'jobfinder-8ceb9.firebaseapp.com',
      databaseURL: 'https://jobfinder-8ceb9.firebaseio.com',
      storageBucket: 'jobfinder-8ceb9.appspot.com',
      //locale: 'nam5 (us-central)'
    ),
  );
  //await FirebaseAppCheck.instance.activate();
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);
  await FirebaseAuth.instance.signOut();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'jobfinder',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text(
                  'An error has occurred',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        /*FirebaseAuth.instance
            .setSettings(appVerificationDisabledForTesting: true);*/

        return MaterialApp(
          locale: const Locale('nam5 (us-central)'),
          debugShowCheckedModeBanner: false,
          title: "jobfinder",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            //scaffoldBackgroundColor: Colors.white,
            //primarySwatch: Colors.blue,
          ),
          home: UserState(),
        );
      },
    );
  }
}
