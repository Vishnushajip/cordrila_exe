import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cordrila_exe/Pages/Admin_Utr/Admin_Utr_All.dart';
import 'package:cordrila_exe/Pages/Admin_Utr/Admin_Utr_daily.dart';
import 'package:cordrila_exe/Pages/Admin_fresh/Admin_fresh_daily.dart';
import 'package:cordrila_exe/Pages/signinpage.dart';
import 'package:cordrila_exe/Pages/splashscreen.dart';
import 'package:cordrila_exe/Stations/ALWD_Admin/ALWDShoppingAll.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDAdmin_Utr/COKDAdmin_Utr_All.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDAdmin_Utr/COKDAdmin_Utr_Monthly.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDAdmin_Utr/COKDAdmin_Utr_daily.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDShoppingAll.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDShoppingDaily.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKDShoppingMonthly.dart';
import 'package:cordrila_exe/Stations/COKD_Admin/COKD_Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Admin_Shopping/Admin_shopping_All.dart';
import 'Pages/Admin_Shopping/Admin_shopping_daily.dart';
import 'Pages/Admin_Shopping/Admin_shopping_monthly.dart';
import 'Pages/Admin_Utr/Admin_Utr_Monthly.dart';
import 'Pages/Admin_fresh/Admin_fresh_All.dart';
import 'Pages/Admin_fresh/Admin_fresh_monthly.dart';
import 'Pages/Admin_req.dart';
import 'Pages/AdminshoppingPage.dart';
import 'Pages/Homepage.dart';
import 'Pages/Togggle_button.dart';
import 'Pages/admin_freshPage.dart';
import 'Pages/admin_utr.dart';
import 'Pages/search_name.dart';
import 'Stations/ALWD_Admin/ALWDAdmin_Utr/ALWDAdmin_Utr_All.dart';
import 'Stations/ALWD_Admin/ALWDAdmin_Utr/ALWDAdmin_Utr_Monthly.dart';
import 'Stations/ALWD_Admin/ALWDAdmin_Utr/ALWDAdmin_Utr_daily.dart';
import 'Stations/ALWD_Admin/ALWDShoppingDaily.dart';
import 'Stations/ALWD_Admin/ALWDShoppingMonthly.dart';
import 'Stations/ALWD_Admin/ALWD_Home.dart';
import 'Stations/KOCHI_Admin/PNKPFreshAll.dart';
import 'Stations/KOCHI_Admin/PNKPFreshDaily.dart';
import 'Stations/KOCHI_Admin/PNKPFreshonthly.dart';
import 'Stations/KOCHI_Admin/PNKP_Home.dart';
import 'Stations/TVM_Admin/PNTVFreshAll.dart';
import 'Stations/TVM_Admin/PNTVFreshDaily.dart';
import 'Stations/TVM_Admin/PNTVShoppingMonthly.dart';
import 'Stations/TVM_Admin/PNTV_Home.dart';
import 'Stations/TRVM_Admin/TRVMAdmin_Utr/TRVMAdmin_Utr_All.dart';
import 'Stations/TRVM_Admin/TRVMAdmin_Utr/TRVMAdmin_Utr_Monthly.dart';
import 'Stations/TRVM_Admin/TRVMAdmin_Utr/TRVMAdmin_Utr_daily.dart';
import 'Stations/TRVM_Admin/TRVMShoppingAll.dart';
import 'Stations/TRVM_Admin/TRVMShoppingDaily.dart';
import 'Stations/TRVM_Admin/TRVMShoppingMonthly.dart';
import 'Stations/TRVM_Admin/TRVM_Home.dart';
import 'Stations/TRVY_Admin/TRVYAdmin_Utr/TRVYAdmin_Utr_All.dart';
import 'Stations/TRVY_Admin/TRVYAdmin_Utr/TRVYAdmin_Utr_Monthly.dart';
import 'Stations/TRVY_Admin/TRVYAdmin_Utr/TRVYAdmin_Utr_daily.dart';
import 'Stations/TRVY_Admin/TRVYShoppingAll.dart';
import 'Stations/TRVY_Admin/TRVYShoppingDaily.dart';
import 'Stations/TRVY_Admin/TRVYShoppingMonthly.dart';
import 'Stations/TRVY_Admin/TRVY_Home.dart';
import 'Stations/TVCY_Admin/TVCYShoppingAll.dart';
import 'Stations/TVCY_Admin/TVCYShoppingDaily.dart';
import 'Stations/TVCY_Admin/TVCYShoppingMonthly.dart';
import 'Stations/TVCY_Admin/TVCY_Home.dart';
import 'controller/Password_Provider.dart';
import 'controller/UploadCsv_Provider.dart';
import 'controller/Welcome_message.dart';
import 'controller/password_provider copy.dart';

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
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  runApp(
    MultiProvider(
      providers: [
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
        ChangeNotifierProvider(create: (_) => ToggleProvider()),
        ChangeNotifierProvider<FreshFilterProviderAll>(
          create: (_) => FreshFilterProviderAll(),
        ),
        ChangeNotifierProvider<FreshFilterProviderDaily>(
          create: (_) => FreshFilterProviderDaily(),
        ),
        ChangeNotifierProvider<FreshFilterProviderMonthly>(
          create: (_) => FreshFilterProviderMonthly(),
        ),
        ChangeNotifierProvider(create: (_) => ToggleProvider()),
        ChangeNotifierProvider<ShoppingProviderAll>(
          create: (_) => ShoppingProviderAll(),
        ),
        ChangeNotifierProvider<ShoppingProviderDaily>(
          create: (_) => ShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<ShoppingProviderMonthly>(
          create: (_) => ShoppingProviderMonthly(),
        ),
        ChangeNotifierProvider<UtrProviderAll>(
          create: (context) => UtrProviderAll(),
        ),
        ChangeNotifierProvider<UtrProviderDaily>(
          create: (context) => UtrProviderDaily(),
        ),
        ChangeNotifierProvider<UtrProviderMonthly>(
          create: (context) => UtrProviderMonthly(),
        ),

        ChangeNotifierProvider<PasswordProvider>(
          create: (context) => PasswordProvider(),
        ),
        ChangeNotifierProvider<COKDShoppingProviderAll>(
          create: (context) => COKDShoppingProviderAll(),
        ),
        ChangeNotifierProvider<COKDShoppingProviderDaily>(
          create: (context) => COKDShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<COKDShoppingProviderMonthly>(
          create: (context) => COKDShoppingProviderMonthly(),
        ),

        ChangeNotifierProvider<ALWDShoppingProviderAll>(
          create: (context) => ALWDShoppingProviderAll(),
        ),
        ChangeNotifierProvider<ALWDShoppingProviderDaily>(
          create: (context) => ALWDShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<ALWDShoppingProviderMonthly>(
          create: (context) => ALWDShoppingProviderMonthly(),
        ),
        // bjhbjhihh
        ChangeNotifierProvider<PNKPFreshProviderAll>(
          create: (context) => PNKPFreshProviderAll(),
        ),
        ChangeNotifierProvider<PNKPShoppingProviderDaily>(
          create: (context) => PNKPShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<PNKPShoppingProviderMonthly>(
          create: (context) => PNKPShoppingProviderMonthly(),
        ),
        // JOJK
        ChangeNotifierProvider<PNTVShoppingProviderAll>(
          create: (context) => PNTVShoppingProviderAll(),
        ),
        ChangeNotifierProvider<PNTVShoppingProviderDaily>(
          create: (context) => PNTVShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<PNTVShoppingProviderMonthly>(
          create: (context) => PNTVShoppingProviderMonthly(),
        ),

        ChangeNotifierProvider<LoadingProvider>(
          create: (context) => LoadingProvider(),
        ),

        ChangeNotifierProvider<TRVMShoppingProviderAll>(
          create: (context) => TRVMShoppingProviderAll(),
        ),
        ChangeNotifierProvider<TRVMShoppingProviderDaily>(
          create: (context) => TRVMShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<TRVMShoppingProviderMonthly>(
          create: (context) => TRVMShoppingProviderMonthly(),
        ),
        ChangeNotifierProvider<TRVYShoppingProviderAll>(
          create: (context) => TRVYShoppingProviderAll(),
        ),
        ChangeNotifierProvider<TRVYShoppingProviderDaily>(
          create: (context) => TRVYShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<TRVYShoppingProviderMonthly>(
          create: (context) => TRVYShoppingProviderMonthly(),
        ),
        // HH
        ChangeNotifierProvider<TVCYShoppingProviderAll>(
          create: (context) => TVCYShoppingProviderAll(),
        ),
        ChangeNotifierProvider<TVCYShoppingProviderDaily>(
          create: (context) => TVCYShoppingProviderDaily(),
        ),
        ChangeNotifierProvider<TVCYShoppingProviderMonthly>(
          create: (context) => TVCYShoppingProviderMonthly(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => COKDUtrProviderAll()),
        ChangeNotifierProvider(create: (_) => COKDUtrProviderDaily()),
        ChangeNotifierProvider(create: (_) => COKDUtrProviderMonthly()),
        ChangeNotifierProvider(create: (_) => ALWDUtrProviderAll()),
        ChangeNotifierProvider(create: (_) => ALWDUtrProviderDaily()),
        ChangeNotifierProvider(create: (_) => ALWDUtrProviderMonthly()),
        ChangeNotifierProvider(create: (_) => TRVMUtrProviderAll()),
        ChangeNotifierProvider(create: (_) => TRVMUtrProviderDaily()),
        ChangeNotifierProvider(create: (_) => TRVMUtrProviderMonthly()),

        ChangeNotifierProvider(create: (_) => TRVYUtrProviderAll()),
        ChangeNotifierProvider(create: (_) => TRVYUtrProviderDaily()),
        ChangeNotifierProvider(create: (_) => TRVYUtrProviderMonthly()),
        ChangeNotifierProvider(create: (_) => WelcomeMessageProvider()),
        ChangeNotifierProvider(create: (_) => ExcelUploadProvider()),

        ChangeNotifierProvider<PasswordVisibilityProvider>(
          create: (context) => PasswordVisibilityProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/alwd': (context) => ALWDHomePage(),
        '/cokd': (context) => COKDHomePage(),
        '/pnkp': (context) => PNKPHomePage(),
        '/pntv': (context) => PNTVHomePage(),
        '/trvy': (context) => TRVYHomePage(),
        '/tvcy': (context) => TVCYHomePage(),
        '/trvm': (context) => TRVMHomePage(),
      },
    );
  }
}

Future<void> saveUserDetails(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  print('Saved userId to SharedPreferences: $userId');
}

Future<String?> getUserDetails() async {
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  print('Retrieved userId from SharedPreferences: $userId');
  return userId;
}
