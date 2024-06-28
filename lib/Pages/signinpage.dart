import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/req_provider.dart';
import '../controller/signinpage_provider.dart';
import 'forgotpassword.dart';
import 'Navigate.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _clearLoginFields() {
    _idController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<SigninpageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 50.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: AssetImage(
                          'assets/LOGO.jpg',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Cordrila',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins',
                              ),
                            ),
                            Text(
                              'Infrastructure Pvt Ltd',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 9.0,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      height: 300,
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _idController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  CupertinoIcons.number,
                                  color: Colors.grey.shade500,
                                ),
                                hintText: 'Enter your ID',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: _passwordController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey.shade500,
                                ),
                                hintText: 'Password',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    appStateProvider.obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed:
                                      appStateProvider.togglePasswordVisibility,
                                ),
                              ),
                              obscureText: appStateProvider.obscurePassword,
                            ),
                            const SizedBox(height: 50.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: appStateProvider.isLoading
                                    ? null
                                    : () async {
                                        if (_idController.text.isEmpty ||
                                            _passwordController.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Please fill in all fields')),
                                          );
                                          return;
                                        }

                                        appStateProvider.setLoading(true);

                                        final userId = _idController.text;
                                        final password =
                                            _passwordController.text;

                                        try {
                                          bool isValid = await appStateProvider
                                              .validatePassword(
                                                  userId, password);
                                          if (isValid) {
                                            // Save user data upon successful authentication
                                            await appStateProvider.saveUserData(
                                                userId, password);
                                            Provider.of<AdminRequestProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchRequests();

                                            // Navigate to the appropriate page
                                            navigateToHomePage(
                                                context, appStateProvider);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Invalid ID or Password')),
                                            );
                                          }
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to authenticate: $error')),
                                          );
                                        } finally {
                                          appStateProvider.setLoading(false);
                                        }
                                        _clearLoginFields();
                                      },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  elevation: 5,
                                ),
                                child: appStateProvider.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage()));
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.black38),
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
            ),
          ),
        ),
      ),
    );
  }
}
