import 'package:cordrila_exe/Pages/search_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Admin_req.dart';
import 'AdminshoppingPage.dart';
import 'admin_freshPage.dart';
import 'admin_utr.dart';
import 'transition.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 166, 165, 165),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 80, bottom: 10, left: 25),
                    child: Image.asset("assets/run.gif"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "You Shop We Deliver.",
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 20,
                    left: 20,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("assets/photo_2024-05-14_10-22-21.jpg"),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 20,
                    left: 20,
                    child: Padding(
                      padding: EdgeInsets.only(left: 70),
                      child: Text(
                        "Cordrila",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 60,
                    left: 20,
                    child: Padding(
                      padding: EdgeInsets.only(left: 70),
                      child: Text(
                        "Infrastructure Pvt Ltd",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Consumer<AdminRequestProvider>(
                      builder: (context, provider, child) {
                        return Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const AdminRequestPage(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                color: Colors.black,
                                CupertinoIcons.bell,
                                size: 50,
                              ),
                            ),
                            if (!provider.isViewed)
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                      _getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      height: 900,
                      width: 900,
                      child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const TransitionPage(
                                        destination: AdminShoppingPage());
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return child;
                                  },
                                ),
                              );
                            },
                            child: Card(
                              elevation: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/deliveryboy.png",
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.shopping_bag_outlined),
                                        SizedBox(height: 2),
                                        Text(
                                          'Shopping',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text('Amazon Delivery'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const TransitionPage(
                                        destination: FreshFilterPage());
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return child;
                                  },
                                ),
                              );
                            },
                            child: Card(
                              elevation: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/9960462-removebg-preview.png',
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                            Icons.local_grocery_store_outlined),
                                        SizedBox(height: 2),
                                        Text(
                                          "Fresh",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text('More Delivery'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const TransitionPage(
                                        destination: AdminUtrPage());
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return child;
                                  },
                                ),
                              );
                            },
                            child: Card(
                              elevation: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/—Pngtree—business meeting with client_7284725.png",
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.people_alt_outlined),
                                        SizedBox(height: 2),
                                        Text(
                                          'UTR',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                             Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SearchUser(),
                            ),
                          );
                            },
                            child: const Card(
                              elevation: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 150,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.person),
                                        SizedBox(height: 2),
                                        Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate() {
    DateTime now =
        DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy').format(now);
  }
}
