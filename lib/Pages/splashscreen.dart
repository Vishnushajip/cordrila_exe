import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/signinpage_provider.dart';
import 'Navigate.dart';
import 'signinpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    // Delay for splash screen duration
    await Future.delayed(const Duration(milliseconds: 3000));

    final appStateProvider =
        Provider.of<SigninpageProvider>(context, listen: false);
    bool isLoggedIn = await appStateProvider.loadUserData();

    if (isLoggedIn) {
      navigateToHomePage(context, appStateProvider);
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const SigninPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(
                'assets/photo_2024-05-14_10-22-21.jpg',
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Cordrila',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          Text(
            'Infrastructure Private Limited',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
