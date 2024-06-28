import 'package:flutter/material.dart';

import 'AdminshoppingPage.dart';
import 'admin_freshPage.dart';
import 'transition.dart';

class TaskManagerHomePage extends StatelessWidget {
  const TaskManagerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // Add some top padding
            const Text(
              'Hello,Guest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getFormattedDate(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.only(bottom: 25, right: 10, left: 10),
                reverse: false,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const TransitionPage(
                              destination: AdminShoppingPage());
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    ),
                    child: const TaskCard(
                      title: 'Shopping',
                      subtitle: 'Amazon Delivery',
                      icon: Icons.inventory,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const TransitionPage(
                              destination: FreshFilterPage());
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    ),
                    child: const TaskCard(
                      title: 'Fresh',
                      subtitle: 'More Delivery',
                      icon: Icons.delivery_dining,
                    ),
                  ),
                  const TaskCard(
                    title: 'Requests',
                    subtitle: 'Staff Requests',
                    icon: Icons.mail_sharp,
                  ),
                  const TaskCard(
                    title: 'My Profile',
                    subtitle: 'Hello,Guest',
                    icon: Icons.person,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskStatus extends StatelessWidget {
  final String title;
  final String count;

  const TaskStatus({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TaskCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20, // Adjust height as needed
      width: 20, // Adjust width as needed
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.teal), // Reduced icon size
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold), // Reduced font size
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey), // Reduced font size
            ),
          ],
        ),
      ),
    );
  }
}

String _getFormattedDate() {
  DateTime now =
      DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  String formattedDate = ' ${now.day} ${_getMonth(now)} ${now.year}';
  return formattedDate;
}

String _getMonth(DateTime date) {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[date.month - 1];
}
