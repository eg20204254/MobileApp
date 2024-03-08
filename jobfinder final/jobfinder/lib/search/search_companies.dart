import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/widgets/all_companies_widget.dart';
import 'package:jobfinder/widgets/bottom_nav_bar.dart';

class AllWorkerscreen extends StatefulWidget {
  @override
  State<AllWorkerscreen> createState() => _AllWorkerscreenState();
}

class _AllWorkerscreenState extends State<AllWorkerscreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search Query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for users ...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          _clearSearchQuery();
        },
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
      )
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
            ),
          ),
          automaticallyImplyLeading: false,
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                final filteredUsers = snapshot.data!.docs.where((doc) {
                  final userName = doc['name'] as String? ?? '';
                  return userName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                if (filteredUsers.isNotEmpty) {
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AllWorkersWidget(
                        userId: filteredUsers[index]['id'],
                        userName: filteredUsers[index]['name'],
                        userEmail: filteredUsers[index]['email'],
                        usercontactNumber: filteredUsers[index]['phoneNumber'],
                        userImageUrl: filteredUsers[index]['userImage'],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("There are no matching users"),
                  );
                }
              } else {
                return const Center(
                  child: Text("There are no users"),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          },
        ),
      ),
    );
  }
}
