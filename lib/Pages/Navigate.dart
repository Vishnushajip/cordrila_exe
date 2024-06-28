
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controller/signinpage_provider.dart';
import 'AdminHome.dart';
import 'Dummy_shopping.dart';
import 'dummy_utr.dart';
import 'dummyfresh.dart';

void navigateToHomePage(
    BuildContext context, SigninpageProvider appStateProvider) {
  final userType = appStateProvider.userData?['Location'];

  if (userType == 'Shopping') {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const ShoppingPage()));
  } else if (userType == 'UTR') {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const UtrPage()));
  } else if (userType == 'Fresh') {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const FreshPage()));
  } else if (userType == 'Admin') {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const TaskPage()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unknown user type')),
    );
  }
}
