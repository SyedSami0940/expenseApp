import 'package:expenseapp/firebase_options.dart';
import 'package:expenseapp/screen/dashboardScreen.dart';
import 'package:expenseapp/screen/expense/expense_Dashboard.dart';
import 'package:expenseapp/screen/loginScreen.dart';
import 'package:expenseapp/screen/signupScren.dart';
import 'package:expenseapp/screen/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: DashboardscreenView(),
    );
  }
}
