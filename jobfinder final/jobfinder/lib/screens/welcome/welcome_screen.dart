import 'package:flutter/material.dart';
//import 'package:jobfinder/screens/home/home_screen.dart';
import 'package:jobfinder/screens/login/login_screen.dart';
//import 'package:jobfinder/search/search_job.dart';
//import 'package:jobfinder/screens/home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: SizedBox(
            width: 500,
            height: 500,
            child: Login(),
            /*child: SingleChildScrollView(
              child: Login(),
            ),*/
          ),
          contentPadding: EdgeInsets.all(20),
          //constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/jobs.jpg', height: 250),
                const SizedBox(height: 20),
                Text("Secure your Future \nwith your dream job",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 10),
                const Text(
                  'Here you can find a job according with your mind thinking and your degree.You can find your dream here with just few clicks.',
                  style: TextStyle(
                    height: 1.5,
                    //fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                SizedBox(
                  width: 360,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLoginDialog(context);
                      //Navigator.of(context).pop();
                      /*Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SearchScreen()));*/
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15)),
                    //minimumSize: const Size(0, 0),
                    child: const Text(
                      'Explore Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
