//import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfinder/screens/jobs/persistent.dart';
import 'package:jobfinder/services/global_methods.dart';
import 'package:jobfinder/services/global_variables.dart';
import 'package:jobfinder/widgets/bottom_nav_bar.dart';
import 'package:uuid/uuid.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({super.key});

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _deadlineController.dispose();
  }

  final TextEditingController _jobCategoryController =
      TextEditingController(text: 'Select job category');
  final TextEditingController _jobTitleController =
      TextEditingController(text: '');
  final TextEditingController _jobDescriptionController =
      TextEditingController(text: '');
  final TextEditingController _deadlineController =
      TextEditingController(text: '');
  final TextEditingController _companyNameController =
      TextEditingController(text: '');
  final TextEditingController _locationController =
      TextEditingController(text: '');

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      //displaying showDialog ,we tap on textfield
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.black,
          ),
          maxLines: valueKey == 'JobDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 230, 230, 230),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
        ),
      ),
    );
  }

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
                        _jobCategoryController.text =
                            Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
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
          );
        });
  }

  void _pickedDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(
          const Duration(days: 0),
        ),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        _deadlineController.text =
            '${picked!.year} - ${picked!.month} - ${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_deadlineController.text == "Choose job Deadline date" ||
          _jobCategoryController.text == 'Choose job category') {
        GlobalMethod.showErrorDialog(
            error: "Please pick everything", ctx: context);
        return;
      }

      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).set({
          'jobId': jobId,
          'jobTitle': _jobTitleController.text,
          'uploadBy': _uid,
          'email': user.email,
          'jobDescription': _jobDescriptionController.text,
          'deadline': _deadlineController.text,
          'deadlinedateTimestamp': deadlineDateTimeStamp,
          'jobCategory': _jobCategoryController.text,
          'createdAt': Timestamp.now(),
          //'recruitment': true,
          'companyName': _companyNameController.text,
          'name': _jobTitleController.text,
          //'companyImage': companyImageUrl,
          'location': _locationController.text,
          'applicants': 0,
          /*'jobId': jobId,
          'uploadBy': _uid,
          'email': user.email,
          'jobTitle': _jobDescriptionController.text,
          'deadline': _deadlineController.text,
          'deadlinedateTimestamp': deadlineDateTimeStamp,
          'jobcatergory': _jobCategoryController.text,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,*/
        });
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Choose job category";
          _deadlineController.text = "Choose job Deadline date";
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Its not vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(indexNum: 2),
        backgroundColor: Colors.transparent,
        /*appBar: AppBar(
          title: const Text('Upload Job Now'),
          foregroundColor: Colors.white,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
            ),
          ),
        ),*/
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0, left: 60.0),
                      child: Text(
                        'Upload Job Details',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //const SizedBox(height: 16),
                    //const SizedBox(width: 160),
                    _textTitles(label: 'Job Catergory:'),
                    _textFormFields(
                      valueKey: 'JobCateory',
                      controller: _jobCategoryController,
                      enabled: false,
                      fct: () {
                        _showTaskCategoriesDialog(size: size);
                      },
                      maxLength: 100,
                    ),
                    _textTitles(label: 'Job title:'),
                    _textFormFields(
                      valueKey: 'JobTitle',
                      controller: _jobTitleController,
                      enabled: true,
                      fct: () {},
                      maxLength: 100,
                    ),
                    _textTitles(label: 'Company Name:'),
                    _textFormFields(
                      valueKey: 'CompanyName',
                      controller: _companyNameController,
                      enabled: true,
                      fct: () {},
                      maxLength: 100,
                    ),
                    _textTitles(label: 'Location:'),
                    _textFormFields(
                      valueKey: 'Location',
                      controller: _locationController,
                      enabled: true,
                      fct: () {},
                      maxLength: 100,
                    ),
                    _textTitles(label: 'Job Description:'),
                    _textFormFields(
                      valueKey: 'JobDescription',
                      controller: _jobDescriptionController,
                      enabled: true,
                      fct: () {},
                      maxLength: 100,
                    ),
                    _textTitles(label: 'Job Deadline:'),
                    _textFormFields(
                      valueKey: 'JobDeadline',
                      controller: _deadlineController,
                      enabled: false,
                      fct: () {
                        _pickedDateDialog();
                      },
                      maxLength: 100,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _uploadTask();
                                },
                                //Create postjob,
                                color: Colors.deepPurple,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Post Now',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 9,
                                        ),
                                        Icon(
                                          Icons.upload_file,
                                          color: Colors.white,
                                        ),
                                      ]),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        /*body: const Center(
            child: Padding(
          padding: EdgeInsets.all(7.0),
          child: Card(
            color: Colors.white10,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Please fill all fields',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textTitles(label: 'Job Category:'),
                    ],
                  ),
                ),)
              ],
            )),
          ),
        )),*/
      ),
    );
    /*//child:
    Scaffold(
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Job Uploading',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textTitles(label: 'Job Catergory:'),
                  _textFormFields(
                    valueKey: 'JobCateory',
                    controller: _jobCategoryController,
                    enabled: false,
                    fct: () {
                      _showTaskCategoriesDialog(size: size);
                    },
                    maxLength: 100,
                  ),
                  _textTitles(label: 'Job title:'),
                  _textFormFields(
                    valueKey: 'JobTitle',
                    controller: _jobTitleController,
                    enabled: true,
                    fct: () {},
                    maxLength: 100,
                  ),
                  _textTitles(label: 'Company Name:'),
                  _textFormFields(
                    valueKey: 'CompanyName',
                    controller: _companyNameController,
                    enabled: true,
                    fct: () {},
                    maxLength: 100,
                  ),
                  _textTitles(label: 'Location:'),
                  _textFormFields(
                    valueKey: 'Location',
                    controller: _locationController,
                    enabled: true,
                    fct: () {},
                    maxLength: 100,
                  ),
                  _textTitles(label: 'Job Description:'),
                  _textFormFields(
                    valueKey: 'JobDescription',
                    controller: _jobDescriptionController,
                    enabled: true,
                    fct: () {},
                    maxLength: 100,
                  ),
                  _textTitles(label: 'Job Deadline:'),
                  _textFormFields(
                    valueKey: 'JobDeadline',
                    controller: _deadlineController,
                    enabled: false,
                    fct: () {
                      _pickedDateDialog();
                    },
                    maxLength: 100,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : MaterialButton(
                              onPressed: () {
                                _uploadTask();
                              },
                              //Create postjob,
                              color: Colors.black,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Post Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Icon(
                                        Icons.upload_file,
                                        color: Colors.white,
                                      ),
                                    ]),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );*/
    //);
  }
}
