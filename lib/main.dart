import "package:doit_list/StyleClasses/main_style.dart";
import "package:doit_list/pages/testpage.dart";
import "package:flutter/material.dart";
import "package:doit_list/pages/home.dart";
import "package:doit_list/pages/main_screen.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:doit_list/pages/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: MainColors.appBarColor_beta,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => MainScreen(),
        "/sign_in": (context) => SignInPage(),
        "/todo": (context) => Home(),
        "/testpage": (context) => UltraSimpleCalendar()
      },
    );
  }
}
