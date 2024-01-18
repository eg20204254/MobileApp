import 'package:flutter/material.dart';
import 'package:jobfinder/widgets/bottom_nav_bar.dart';

class AllWorkerscreen extends StatefulWidget {
  @override
  State<AllWorkerscreen> createState() => _AllWorkerscreenState();
}

class _AllWorkerscreenState extends State<AllWorkerscreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(indexNum: 1),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('All Workers Screen'),
          foregroundColor: Colors.white,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
