import 'package:cordrila_exe/Pages/signinpage.dart';
import 'package:cordrila_exe/controller/Password_Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _empCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordValid(String password) {
    final RegExp passwordExp =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    return passwordExp.hasMatch(password);
  }

  Future<void> _changePassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('EmpCode', isEqualTo: _empCodeController.text)
          .get();

      Navigator.of(context).pop();

      if (querySnapshot.docs.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Employee code not found'),
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
        return;
      }

      await querySnapshot.docs.first.reference.update({
        'Password': _newPasswordController.text,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content:
                Text('Password changed successfully. Restart the application.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to change password: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoDialogRoute(
                builder: (context) => LoginPage(),
                context: context,
              ),
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Change Password',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  width: 400,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double formWidth = constraints.maxWidth > 600
                            ? 500
                            : constraints.maxWidth * 0.8;

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(20),
                          width: formWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Employee Code"),
                                      SizedBox(height: 5),
                                      TextFormField(
                                        controller: _empCodeController,
                                        decoration: InputDecoration(
                                          labelText: '',
                                          floatingLabelStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          suffixIcon: Icon(Icons
                                              .format_list_numbered_rounded),
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your employee code';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('New Password'),
                                      SizedBox(height: 5),
                                      TextFormField(
                                        controller: _newPasswordController,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              passwordProvider.isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: passwordProvider
                                                .togglePasswordVisibility,
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                        obscureText:
                                            !passwordProvider.isPasswordVisible,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a new password';
                                          }
                                          if (!_isPasswordValid(value)) {
                                            return 'Password must contain\nat least 1 uppercase,\n1 lowercase, and 1 number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Confirm Password"),
                                      SizedBox(height: 5),
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              passwordProvider
                                                      .isConfirmPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: passwordProvider
                                                .toggleConfirmPasswordVisibility,
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                        obscureText: !passwordProvider
                                            .isConfirmPasswordVisible,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your new password';
                                          }
                                          if (value !=
                                              _newPasswordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 29),
                              Container(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _changePassword();
                                    }
                                  },
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _empCodeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
