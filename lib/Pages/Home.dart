import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'splashscreen.dart';

class Home extends StatefulWidget {
  final FirebaseRemoteConfig remoteConfig;

  const Home({Key? key, required this.remoteConfig}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showUpdateDialog = false;

  @override
  void initState() {
    super.initState();
    // Check for update on initialization
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      await widget.remoteConfig.fetch();
      await widget.remoteConfig.activate();
      // After activation, check if update is required
      bool updateRequired = widget.remoteConfig.getBool("Updatev1");
      setState(() {
        showUpdateDialog = updateRequired;
      });
    } catch (e) {
      print("Error fetching or activating remote config: $e");
      // Handle error: fallback to default behavior or show error UI
      setState(() {
        showUpdateDialog = false; // Default to not showing update dialog
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: showUpdateDialog
          ? showAlertDialog(context, widget.remoteConfig)
          : const SplashScreen(),
    );
  }
}

Future<void> launchURL(String url) async {
  try {
    await url_launcher.launch(url);
  } catch (e) {
    print('Error launching URL: $e');
    // Handle error launching URL on Windows
  }
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero, // Allow frequent fetches
    ),
  );

  try {
    await remoteConfig.fetch();
    await remoteConfig.activate();
  } catch (e) {
    print("Error setting up remote config: $e");
  }

  return remoteConfig;
}

Widget showAlertDialog(BuildContext context, FirebaseRemoteConfig remoteConfig) {
  Widget updateButton = SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        const url = "https://cordrila.com/apk";
        try {
          await launchURL(url);
        } catch (e) {
          print('Error launching URL: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue[500],
      ),
      child: const Text(
        "Update",
        style: TextStyle(
          fontSize: 19,
          color: Colors.white,
        ),
      ),
    ),
  );

  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: Colors.white,
    title: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/software-update.png', // Replace with your image asset path
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 20),
          Text(
            remoteConfig.getString("Title"),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          updateButton,
        ],
      ),
    ),
  );
}
