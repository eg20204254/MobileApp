import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/screens/jobs/jobs_screen.dart';
import 'package:jobfinder/screens/jobs/upload_job.dart';
import 'package:jobfinder/search/company_profile.dart';
import 'package:jobfinder/search/search_companies.dart';
import 'package:jobfinder/user_state.dart';

class BottomNavBar extends StatelessWidget {
  int indexNum = 0;

  BottomNavBar({required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to Log Out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => UserState()));
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepPurple.shade400,
      backgroundColor: Colors.deepPurple.shade200,
      buttonBackgroundColor: Colors.black54,
      height: 50,
      index: indexNum,
      items: const [
        Icon(
          Icons.list,
          size: 20,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          size: 20,
          color: Colors.white,
        ),
        Icon(
          Icons.add,
          size: 20,
          color: Colors.white,
        ),
        Icon(
          Icons.person_pin,
          size: 20,
          color: Colors.white,
        ),
        Icon(
          Icons.exit_to_app,
          size: 20,
          color: Colors.white,
        ),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => JobScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AllWorkerscreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadJob()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        userId: uid,
                      )));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
