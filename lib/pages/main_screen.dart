import 'package:doit_list/StyleClasses/main_style.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("DO IT LIST!", style: TextStyle(color: MainColors.titleTextColor, fontSize: 54),),
          centerTitle: true,
          backgroundColor: MainColors.appBarColor_beta,
        ),
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Main screen", style: TextStyle(fontSize: 54, color: MainColors.titleTextColor),),

            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, "/todo");
              },  style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.buttonBackgroundColor_beta,
              ), child: Text("NOTE PAGE", style: TextStyle(fontSize: 36, color: MainColors.titleTextColor),)),
            ),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, "/testpage");
              },  style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.buttonBackgroundColor_beta,
              ), child: Text("TEST CALENDAR PAGE", style: TextStyle(fontSize: 24, color: MainColors.titleTextColor),)),
            ),

            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, "/sign_in");
              },  style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.buttonBackgroundColor_beta,
              ), child: Text("SIGN IN PAGE", style: TextStyle(fontSize: 36, color: MainColors.titleTextColor),)),
            ),
          ],
        ),
      ),
    );
  }
}
