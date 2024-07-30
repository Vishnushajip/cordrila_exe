import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Stations/ALWD_Admin/ALWD_Home.dart';
import '../Stations/COKD_Admin/COKD_Home.dart';
import '../Stations/KOCHI_Admin/PNKP_Home.dart';
import '../Stations/TVM_Admin/PNTV_Home.dart';
import '../Stations/TRVM_Admin/TRVM_Home.dart';
import '../Stations/TRVY_Admin/TRVY_Home.dart';
import '../Stations/TVCY_Admin/TVCY_Home.dart';
import 'Homepage.dart';
import 'ChangeAdminPassword.dart';

class LoadingProvider extends ChangeNotifier {
  final TextEditingController empCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _login(BuildContext context) async {
    final loginProvider = Provider.of<LoadingProvider>(context, listen: false);
    String empCode = loginProvider.empCodeController.text.trim().toUpperCase();
    String password = loginProvider.passwordController.text.trim();

    loginProvider.setLoading(true);

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('USERS')
          .where('EmpCode', isEqualTo: empCode)
          .where('Password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String employeeName = querySnapshot.docs.first['Employee Name'];
        List<String> allowedNames = [
          'CORA ADMIN',
          'CORA18118COKD',
          'CORA18118ALWD',
          'CORA18118TVCY',
          'CORA18118TRVM',
          'CORA18118TRVY',
          'CORA18118PRIMETVM',
          'CORA18118PRIMEKOCHI',
        ];

        if (allowedNames.contains(employeeName)) {
          bool isWeakPassword = await _checkPasswords(empCode);

          if (isWeakPassword) {
            _showAlert();
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userId', employeeName);

            navigateToAdminHome(employeeName);
          }
        } else {
          _showUnauthorizedAccessDialog();
        }
      } else {
        _showInvalidCredentialsDialog();
      }
    } catch (e) {
      print('Error logging in: $e');
    } finally {
      loginProvider.setLoading(false);
    }
  }

  Future<bool> _checkPasswords(String empCode) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('USERS')
        .where('EmpCode', isEqualTo: empCode)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.exists) {
        String password = doc['Password'];
        if (password == 'LastMile##123') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordPage()),
          );
          return true;
        }
      }
    }

    return false;
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Text('The Entered Password Is Old Try Changing It'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUnauthorizedAccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unauthorized Access'),
          content:
              Text('You do not have permission to access this application.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInvalidCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credentials'),
          content: Text('Please check your EmpCode and Password.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToAdminHome(String employeeName) {
    switch (employeeName) {
      case 'CORA ADMIN':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
        break;
      case 'CORA18118COKD':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => COKDHomePage()),
          (route) => false,
        );
        break;
      case 'CORA18118TRVY':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TRVYHomePage()),
          (route) => false,
        );
        break;
      case 'CORA18118ALWD':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ALWDHomePage()),
          (route) => false,
        );
        break;
      case 'CORA18118TVCY':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TVCYHomePage()),
          (route) => false,
        );
        break;

      case 'CORA18118TRVM':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TRVMHomePage()),
          (route) => false,
        );
        break;
      case 'CORA18118PRIMETVM':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PNTVHomePage()),
          (route) => false,
        );
        break;
      case 'CORA18118PRIMEKOCHI':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PNKPHomePage()),
          (route) => false,
        );
        break;
      default:
        _showUnauthorizedAccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoadingProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 700,
              height: 600,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image(
                      image: AssetImage(
                          "assets/backgroundscaffold-removebg-preview.png"),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 350,
                    child: TextField(
                      controller: loginProvider.empCodeController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'EmpCode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 350,
                    child: TextField(
                      controller: loginProvider.passwordController,
                      obscureText: !loginProvider.isPasswordVisible,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: loginProvider.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        loginProvider.isLoading ? null : () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: loginProvider.isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          if (loginProvider.isLoading)
            Container(
              color: Colors.black45,
            ),
        ],
      ),
    );
  }
}
