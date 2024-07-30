  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:cordrila_exe/Pages/signinpage.dart';
  import 'package:cordrila_exe/controller/Password_Provider.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:provider/provider.dart';
  import 'package:rounded_background_text/rounded_background_text.dart';
  import '../Widgets/Loaders/Spinner.dart';
  import '../Widgets/Loaders/spinner_loader.dart';
  import '../controller/employeeprovider.dart';

  class ChangePasswordPage extends StatefulWidget {
    @override
    _ChangePasswordPageState createState() => _ChangePasswordPageState();
  }

  class _ChangePasswordPageState extends State<ChangePasswordPage> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _empCodeController = TextEditingController();
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    bool _isPasswordValid(String password) {
      final RegExp passwordExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
      return passwordExp.hasMatch(password);
    }

    @override
    void initState() {
      super.initState();
      _clearForm();
    }

    void _clearForm() {
      _empCodeController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }

    Future<void> _changePassword() async {
      Provider.of<EmployeeProvider>(context, listen: false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: BoxLoader());
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
              content: Text('Password changed successfully. Restart the application.'),
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
      final employeeProvider = Provider.of<EmployeeProvider>(context);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 70,
          centerTitle: true,
          backgroundColor: Colors.white,
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
                    width: 700,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.search),
                                              onPressed: () {
                                                employeeProvider
                                                    .fetchEmployeeDetails(
                                                        _empCodeController.text
                                                            .trim());
                                              },
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          
                                          onFieldSubmitted: (value) {
                                            employeeProvider.fetchEmployeeDetails(
                                                value.trim());
                                          },
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
                                if (employeeProvider.isLoading)
                                  Center(child: CyclingWordsWidget())
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RoundedBackgroundText(
                                                  employeeProvider.employeeName,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                  backgroundColor: Colors.blue,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                            ],
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('New Password'),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          controller: _newPasswordController,
                                          decoration: InputDecoration(
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    passwordProvider
                                                            .isPasswordVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                  ),
                                                  onPressed: passwordProvider
                                                      .togglePasswordVisibility,
                                                ),
                                                if (employeeProvider
                                                    .currentPassword.isNotEmpty)
                                                  TextButton(
                                                    child: Text(
                                                      'Show Current Password',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            title: Text('Current Password'),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(employeeProvider.currentPassword),
                                                                    IconButton(
                                                                        onPressed: () {
                                                                          Clipboard.setData(ClipboardData(text: employeeProvider.currentPassword));
                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password copied to clipboard')));
                                                                        },
                                                                        icon: Icon(size: 15, Icons.copy)),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
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
                                                    },
                                                  ),
                                              ],
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          obscureText: !passwordProvider.isPasswordVisible,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Confirm Password"),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          controller: _confirmPasswordController,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                passwordProvider.isConfirmPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: passwordProvider.toggleConfirmPasswordVisibility,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          obscureText: !passwordProvider.isConfirmPasswordVisible,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please confirm your new password';
                                            }
                                            if (value != _newPasswordController.text) {
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
                                Center(
                                  child: Container(
                                    width: 200,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          _changePassword();
                                        }
                                      },
                                      child: Text(
                                        'Change Password',
                                        style: TextStyle(color: Colors.white),
                                      ),
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
