import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:jobfinder/user_state.dart';
import 'package:jobfinder/widgets/bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = "";
  String contactNumber = "";
  String imageUrl = "";
  String joinedAt = "";
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          contactNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            }),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$contactNumber?text=HelloWorld';
    launchUrlString(url);
  }

  void _mailTo() async {
    final Uri params = Uri(
      scheme: 'mailTo',
      path: email,
      query:
          'subject=Write subject here, Please&body=Hello,please  write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async {
    var url = 'tel://$contactNumber';
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(indexNum: 3),
        backgroundColor: Colors.transparent,
        /*appBar: AppBar(
          title: const Text('Company Profile  Screen'),
          foregroundColor: Colors.white,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
            ),
          ),
        ),*/
        body: Center(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Stack(children: [
                      Card(
                        color: const Color.fromARGB(255, 212, 209, 218),
                        margin: EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name == null ? "Name here" : name!,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 99, 66, 157),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Account Information:',
                                  style: TextStyle(
                                      color: Color.fromARGB(136, 33, 32, 32),
                                      fontSize: 20.0),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child:
                                    userInfo(icon: Icons.email, content: email),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: userInfo(
                                    icon: Icons.phone, content: contactNumber),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              _isSameUser
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _contactBy(
                                          color:
                                              Color.fromARGB(255, 61, 135, 63),
                                          fct: () {
                                            _openWhatsAppChat();
                                          },
                                          icon: FontAwesome.whatsapp,
                                        ),
                                        _contactBy(
                                          color:
                                              Color.fromARGB(255, 201, 64, 54),
                                          fct: () {
                                            _mailTo();
                                          },
                                          icon: Icons.mail_outline,
                                        ),
                                        _contactBy(
                                          color:
                                              Color.fromARGB(255, 116, 33, 130),
                                          fct: () {
                                            _callPhoneNumber();
                                          },
                                          icon: Icons.call,
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                height: 25,
                              ),

                              /*const SizedBox(
                                height: 25,
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 25,
                              ),*/
                              !_isSameUser
                                  ? Container()
                                  : Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: MaterialButton(
                                          onPressed: () {
                                            _auth.signOut();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserState()));
                                          },
                                          color: Colors.black,
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Logout',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 9,
                                                  ),
                                                  Icon(
                                                    Icons.logout,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 6,
                                    color: Color.fromARGB(255, 70, 49, 41)
                                    /*Theme.of(context).scaffoldBackgroundColor,*/
                                    ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                    imageUrl == null
                                        ? 'https://cdn3.iconfinder.com/data/icons/e-commerce-8/91/account-512.png'
                                        : imageUrl,
                                  ),
                                  fit: BoxFit.fill,
                                )),
                          )
                        ],
                      )
                    ]),
                  ),
                ),
        ),
      ),
    );
  }
}
