import 'package:cordrila_exe/Pages/signinpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtrPage extends StatelessWidget {
  const UtrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 229, 229),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/loading.gif",
              height: 150,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text("Sorry You Are Not An Admin"),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) =>  LoginPage()));
                },
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
