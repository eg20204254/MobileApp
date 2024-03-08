import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/screens/jobs/persistent.dart';
//import 'package:jobfinder/screens/jobs/jobs_screen.dart';
//import 'package:flutter_application_2/screens/home/widgets/popular_job.dart';
//import 'package:flutter_application_2/screens/home/widgets/recent_job.dart';

class Homescreen extends StatefulWidget {
  //const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? jobCatergoryFilter;

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
                        jobCatergoryFilter = Persistent.jobCategoryList[index];
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset('assets/images/menu.png'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white70)),
                const SizedBox(height: 5),
                Text('Find the best Job \nFor You!',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        height: 1.3,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                            hintText: 'Search the job',
                            hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            border: InputBorder.none,
                            prefixIcon: Icon(CupertinoIcons.search)),
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list_sharp,
                            color: Colors.white),
                        onPressed: () {
                          _showTaskCategoriesDialog(size: size);
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
          /*Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 15),
              children: [
                ListTile(
                  title: Text('Recent Jobs',
                      style: Theme.of(context).textTheme.titleLarge),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('See more'),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: PageView(
                    children: const [RecentJob(), RecentJob(), RecentJob()],
                  ),
                ),
                ListTile(
                  title: Text('Job Categories',
                      style: Theme.of(context).textTheme.titleLarge),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('See more'),
                  ),
                ),
                const PopularJob(
                  imageUrl: 'assests/images/Engineering.jpg',
                  jobTitle: 'Engineering and Architecture',
                ),
                const PopularJob(
                  imageUrl: 'assests/images/Networking.jpg',
                  jobTitle: 'IT & Networking',
                ),
                const PopularJob(
                  imageUrl: 'assests/images/medicine.jpg',
                  jobTitle: 'Helathcare',
                ),
                const PopularJob(
                  imageUrl: 'assests/images/Sales.png',
                  jobTitle: 'Sales and Marketing',
                ),
                const PopularJob(
                  imageUrl: 'assests/images/Education.png',
                  jobTitle: 'Education',
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
