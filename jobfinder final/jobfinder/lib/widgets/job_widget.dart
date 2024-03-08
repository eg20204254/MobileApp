import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfinder/services/global_methods.dart';
import 'package:jobfinder/screens/jobs/job_details.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String companyName;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String companyImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  final String jobCategory;

  const JobWidget({
    required this.jobTitle,
    required this.companyName,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.companyImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
    required this.jobCategory,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to delete this job?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (widget.uploadedBy == _uid) {
                    await FirebaseFirestore.instance
                        .collection('jobs')
                        .doc(widget.jobId)
                        .delete();
                    await Fluttertoast.showToast(
                      msg: 'Job has been deleted',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 18,
                    );
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  } else {
                    GlobalMethod.showErrorDialog(
                        error: 'You cannot perform this action', ctx: ctx);
                  }
                } catch (error) {
                  GlobalMethod.showErrorDialog(
                      error: 'This post cannot be deleted!', ctx: ctx);
                } finally {}
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(31, 86, 86, 86),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => JobDetailsScreen(
                        uploadedBy: widget.uploadedBy,
                        jobId: widget.jobId,
                      )));
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: Image.network(widget.companyImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.companyName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
