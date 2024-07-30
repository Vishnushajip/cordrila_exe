import 'package:cordrila_exe/Pages/signinpage.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDAdmin_Utr/COKDAdmin_Utr_All.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';

import 'COKDShoppingAll.dart';

class COKDHomePage extends StatefulWidget {
  const COKDHomePage({super.key});

  @override
  _COKDHomePageState createState() => _COKDHomePageState();
}

class _COKDHomePageState extends State<COKDHomePage> {
  int _selectedIndex = 0;
  final int _unreadCount = 1;

  final List<Widget> _pages = [
    const COKDShoppingPageAll(),
    const COKDAdminUtrAll(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRailTheme(
            data: const NavigationRailThemeData(
              groupAlignment: BorderSide.strokeAlignCenter,
              indicatorColor: Color.fromARGB(255, 32, 32, 32),
              backgroundColor: Color.fromARGB(255, 32, 32, 32),
              elevation: 40,
              selectedIconTheme: IconThemeData(
                size: 50,
                color: Colors.blue,
              ),
              unselectedIconTheme: IconThemeData(
                size: 50,
                color: Colors.white,
              ),
              labelType: NavigationRailLabelType.all,
            ),
            child: NavigationRail(
              trailing: Padding(
                padding: const EdgeInsets.only(top: 50, right: 40),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      _getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _getFormattedTime(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              leading: SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/AppIcon.jpg"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (context) => COKDHomePage(),
                                        context: context));
                              },
                              child: GestureDetector(
                                onDoubleTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoDialogRoute(
                                          builder: (context) => LoginPage(),
                                          context: context));
                                },
                                child: Text(
                                  "Cordrila",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              minWidth: 200,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: [
                const NavigationRailDestination(
                  icon: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '  Shopping',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  selectedIcon: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '  Shopping ',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  label: Text(''),
                ),
                const NavigationRailDestination(
                  icon: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          Icons.people_alt_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '    UTR           ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  selectedIcon: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          Icons.people_alt_outlined,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '   UTR           ',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          Icons.notifications,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      badges.Badge(
                        badgeContent: Text(
                          _unreadCount.toString(),
                          style:
                              const TextStyle(color: Colors.white, fontSize: 5),
                        ),
                        child: const Text(
                          ' Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  selectedIcon: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          Icons.notifications,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      badges.Badge(
                        badgeContent: Text(
                          _unreadCount.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: const Text(
                          ' Notifications',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  label: const Text(''),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

String _getFormattedDate() {
  DateTime now =
      DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  return DateFormat('dd MMM yyyy').format(now);
}

String _getFormattedTime() {
  DateTime now =
      DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  return DateFormat('hh:mm').format(now);
}
