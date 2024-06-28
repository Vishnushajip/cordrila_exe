import 'package:cordrila_exe/Pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/AdminshoppingPage.dart';
import 'Pages/admin_freshPage.dart';
import 'Pages/admin_utr.dart';
import 'controller/req_provider.dart';
import 'controller/signinpage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDq7H5hIowWvcGmIq7m2RofB843-Eyfz1g",
      authDomain: "cordrila.firebaseapp.com",
      projectId: "cordrila",
      storageBucket: "cordrila.appspot.com",
      messagingSenderId: "861858508386",
      appId: "1:861858508386:web:9e018c02c4332589692b3b",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SigninpageProvider>(
          create: (context) => SigninpageProvider(),
        ),
        ChangeNotifierProvider<AdminRequestProvider>(
          create: (context) => AdminRequestProvider(),
        ),
        ChangeNotifierProvider<AdminRequestProvider>(
          create: (context) => AdminRequestProvider(),
        ),
        ChangeNotifierProvider<ShoppingFilterProvider>(
          create: (_) => ShoppingFilterProvider(),
        ),
        ChangeNotifierProvider<FreshFilterProvider>(
          create: (_) => FreshFilterProvider(),
        ),
        ChangeNotifierProvider<UtrFilterProvider>(
          create: (_) => UtrFilterProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
