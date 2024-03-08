import 'package:flutter/material.dart';
import 'package:jobfinder/search/company_profile.dart';
//import 'package:jobfinder/search/profile_company.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String usercontactNumber;
  final String userImageUrl;

  const AllWorkersWidget({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.usercontactNumber,
    required this.userImageUrl,
  });

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  /*void _mailTo() async {
    var mailUrl = 'mailto:${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');

    if (await canLaunchUrlString(mailUrl)) {
      await launchUrlString(mailUrl);
    } else {
      print('Error');
      throw 'Error Occured';
    }
  }*/

  void _mailTo() async {
    final Uri params = Uri(
      scheme: 'mailTo',
      path: widget.userEmail,
      query:
          'subject=Write subject here, Please&body=Hello,please  write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Color.fromARGB(255, 255, 255, 255),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: widget.userId)));
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
              border: Border(
            right: BorderSide(width: 1),
          )),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
              // ignore: prefer_if_null_operators
              widget.userImageUrl == null
                  ? 'https://cdn3.iconfinder.com/data/icons/e-commerce-8/91/account-512.png' //link
                  : widget.userImageUrl,
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 128, 89, 197),
          ),
        ),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Visit profile',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.mail_outline,
            size: 30,
            color: Color.fromARGB(255, 57, 56, 59),
          ),
          onPressed: () {
            _mailTo();
          },
        ),
      ),
    );
  }
}
