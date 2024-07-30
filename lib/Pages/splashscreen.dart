import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cordrila_exe/Widgets/Loaders/Circle_Loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import '../controller/Welcome_message.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  final _progressStream = StreamController<double>();

  @override
  void dispose() {
    _progressStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUpdateRequired();
  }

  void checkUpdateRequired() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Update')
          .doc('WeC4g1ljaDGvz34hoqV1')
          .get();

      if (snapshot.exists) {
        bool updateRequired = snapshot.get('RemoteV7');
        if (updateRequired) {
          showUpdateAlert(
              'https://firebasestorage.googleapis.com/v0/b/cordrila.appspot.com/o/Cordrila.exe?alt=media&token=e955d9b9-7fce-47a8-82c3-d89ba556f771');
        } else {
          checkLoginStatus();
        }
      } else {
        print('Document does not exist');
        checkLoginStatus();
      }
    } catch (e) {
      print('Error checking update: $e');
      checkLoginStatus();
    }
  }

  Future<void> showUpdateAlert(String url) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Good News', style: TextStyle(fontSize: 20)),
                content: const Text("Version 1.2.7. Available"),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close the dialog
                      await _downloadFile(url);
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _downloadFile(String url) async {
    final dio = Dio();
    final downloadDirectory = Directory('C:\\CordrilaDownloads');

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    final filePath = '${downloadDirectory.path}\\Cordrila.exe';

    try {
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            _progressStream.sink.add(progress);

            setState(() {
              _progress = progress;
            });

            double speed = received / 1024 / 3;
            print('Download speed: ${speed.toStringAsFixed(2)} KB/s');
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download completed: $filePath')),
      );

      await _installDownloadedFile(filePath);
    } catch (e) {
      print('Download failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  Future<void> _installDownloadedFile(String filePath) async {
    try {
      final result = await Process.start(filePath, []);
      await result.exitCode;
    } catch (e) {
      print('Installation failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Installation failed: $e')),
      );
    }
  }

  void checkLoginStatus() async {
    print('Checking login status...');
    String? userId = await getUserDetails();
    print('User ID from SharedPreferences: $userId');

    if (userId != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('USERS')
            .where('EmpCode', isEqualTo: userId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          print('Found matching document, navigating to Admin Home');
          navigateToAdminHome(userId);
        } else {
          print('No document found with matching EmpCode, showing alert');
          showPasswordChangeAlert();
        }
      } catch (e) {
        print('Error fetching documents: $e');
        showPasswordChangeAlert();
      }
    } else {
      print('User ID is null, navigating to LoginPage');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void showPasswordChangeAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Changed', style: TextStyle(fontSize: 20)),
          content:
              Text('Admin has changed your password. Please log in again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateToAdminHome(String userId) {
    print('Navigating to home for user: $userId');
    switch (userId) {
      case 'CORA ADMIN':
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 'CORA18118COKD':
        Navigator.pushReplacementNamed(context, '/cokd');
        break;
      case 'CORA18118ALWD':
        Navigator.pushReplacementNamed(context, '/alwd');
        break;
      case 'CORA18118TVCY':
        Navigator.pushReplacementNamed(context, '/tvcy');
        break;
      case 'CORA18118TRVM':
        Navigator.pushReplacementNamed(context, '/trvm');
        break;
      case 'CORA18118TRVY':
        Navigator.pushReplacementNamed(context, '/trvy');
        break;
      case '  ':
        Navigator.pushReplacementNamed(context, '/pntv');
        break;
      case 'CORA18118PRIMEKOCHI':
        Navigator.pushReplacementNamed(context, '/pnkp');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final welcomeMessageProvider = Provider.of<WelcomeMessageProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/cordila_image.png",
              height: 500,
              width: 550,
            ),
            if (welcomeMessageProvider.isLoading) CircleLoader(),
            SizedBox(height: 20),
            Text(
              '${(_progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
