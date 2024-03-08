//import 'dart:math';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  File? imageFile;
  String? companyImageUrl;

  @override
  void dispose() {
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
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
    final ref = FirebaseStorage.instance
        .ref()
        .child('companyImages')
        .child(jobId + '.jpg');
    await ref.putFile(imageFile!);
    companyImageUrl = await ref.getDownloadURL();

    if (isValid) {
      if (_deadlineController.text == "Choose job Deadline date" ||
          _jobCategoryController.text == 'Choose job category') {
        GlobalMethod.showErrorDialog(
            error: "Please pick everything", ctx: context);
        return;
      } else if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: "Please upload a company image", ctx: context);
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
          'recruitment': true,
          'companyName': _companyNameController.text,
          'name': name,
          'companyImage': companyImageUrl,
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
          msg: 'The data has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        imageFile = null;
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        _companyNameController.clear();
        _locationController.clear();
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

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      name = userDoc.get('name');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera_enhance_sharp,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.deepPurple),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.deepPurple),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
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
                      padding:
                          EdgeInsets.only(top: 20.0, bottom: 20.0, left: 60.0),
                      child: Text(
                        'Upload Job Details',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        _showImageDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 20.0, left: 140.0),
                        child: Container(
                          width: size.width * 0.24,
                          height: size.width * 0.24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: imageFile == null
                                  ? const Icon(
                                      Icons.photo,
                                      color: Colors.black,
                                      size: 40,
                                    )
                                  : Image.file(
                                      imageFile!,
                                      fit: BoxFit.fill,
                                    )),
                        ),
                      ),
                    ),
                    //const SizedBox(height: 16),
                    //const SizedBox(width: 160),
                    _textTitles(label: 'Job Category:'),
                    _textFormFields(
                      valueKey: 'JobCateory',
                      controller: _jobCategoryController,
                      enabled: false,
                      fct: () {
                        _showTaskCategoriesDialog(size: size);
                      },
                      maxLength: 100,
                    ),
                    _textTitles(label: 'Job Title:'),
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
                      maxLength: 150,
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
      ),
    );

    //);
  }
}
