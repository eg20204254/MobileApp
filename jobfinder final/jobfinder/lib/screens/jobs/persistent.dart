import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobfinder/services/global_variables.dart';

class Persistent {
  static List<String> jobCategoryList = [
    'Architecture and Construction',
    'Education',
    'Accounting',
    'IT and Networking',
    'Sales and Marketing',
  ];

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    name = userDoc.get('name');
    userImage = userDoc.get('userImage');
  }
}
