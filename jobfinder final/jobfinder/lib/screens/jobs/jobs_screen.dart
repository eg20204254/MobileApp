import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/screens/jobs/persistent.dart';
import 'package:jobfinder/search/search_job.dart';
import 'package:jobfinder/widgets/bottom_nav_bar.dart';
import 'package:jobfinder/widgets/job_widget.dart';
//import 'package:jobfinder/user_state.dart';

class JobScreen extends StatefulWidget {
  //const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 89, 87, 87),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctxx, index) {
                  return InkWell(
                    onTap: () {
                      //we have used StatefulWidget. therfore should setState(){} for changing the result dynamically
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                          'jobCategoryList[index],${Persistent.jobCategoryList[index]}');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Cancel Filter',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    //Persistent persistentObject = Persistent();
    //persistentObject.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //return const Placeholder();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      //width: double.infinity,
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Job Posts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => SearchScreen()));
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: () {
          CollectionReference<Map<String, dynamic>> collection =
              FirebaseFirestore.instance.collection('jobs');
          Query<Map<String, dynamic>> query =
              collection.where('recruitment', isEqualTo: true);

          if (jobCategoryFilter != null) {
            query = query.where('jobCategory', isEqualTo: jobCategoryFilter);
          }

          return query.orderBy('createdAt', descending: false).snapshots();
        }(), builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return JobWidget(
                      jobTitle: snapshot.data?.docs[index]['jobTitle'],
                      jobDescription: snapshot.data?.docs[index]
                          ['jobDescription'],
                      jobId: snapshot.data?.docs[index]['jobId'],
                      uploadedBy: snapshot.data?.docs[index]['uploadBy'],
                      companyImage: snapshot.data?.docs[index]['companyImage'],
                      name: snapshot.data?.docs[index]['name'],
                      recruitment: snapshot.data?.docs[index]['recruitment'],
                      email: snapshot.data?.docs[index]['email'],
                      location: snapshot.data?.docs[index]['location'],
                      companyName: snapshot.data?.docs[index]['companyName'],
                      jobCategory: snapshot.data?.docs[index]['jobCategory'],
                    );
                  });
            } else {
              return const Center(
                child: Text("There is no jobs"),
              );
            }
          }
          return const Center(
              child: Text(
            'Something went wrong',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ));
        }),
      ),
      /*child: Scaffold(
        appBar: AppBar(
          title: const Text('Jobs Screen'),
        ),
        body: ElevatedButton(
          onPressed: () {
            _auth.signOut();
            Navigator.canPop(context) ? Navigator.pop(context) : null;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => UserState()));
          },
          child: const Text('Logout'),
        ),
      ),*/
    );
  }
}
