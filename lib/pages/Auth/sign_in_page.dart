import 'package:doit_list/StyleClasses/main_style.dart';
import 'package:doit_list/pages/testpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: MainColors.backgroundColor,
      appBar: AppBar(
        title: Text("ACCOUNT LOGIN", style: TextStyle(fontSize: 36, color: MainColors.titleTextColor)),
        centerTitle: true,
        backgroundColor: MainColors.appBarColor_alpha,
      ),
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("SIGN IN", style: TextStyle(
                color: MainColors.titleTextColor,
                fontSize: 48
                ),
            ),
          
            Padding(padding: EdgeInsets.all(40)),
            
            SizedBox(
              height: 100.0,
              width: 350,
              child: TextField(
                cursorColor: MainColors.inputFieldCursorColor,
                decoration: InputDecoration(
                  hintText: 'ENTER EMAIL',
                  filled: true,
                  fillColor: MainColors.inputFieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                style: TextStyle(fontSize: 12.0, height: 2.0, color: MainColors.inputFieldTextColor),
              ),
            ),

            SizedBox(
              height: 100.0,
              width: 350,
              child: TextField(
                cursorColor: MainColors.inputFieldCursorColor,
                decoration: InputDecoration(
                  hintText: 'ENTER PASSWORD',
                  filled: true,
                  fillColor: MainColors.inputFieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                style: TextStyle(fontSize: 12.0, height: 2.0, color: MainColors.inputFieldTextColor),
              ),
            ),

            Padding(padding: EdgeInsets.all(40)),

            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(onPressed: () {

              },  style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.buttonBackgroundColor_alpha,
              ), child: Text("LOG IN", style: TextStyle(fontSize: 24, color: MainColors.titleTextColor),)),
            ),

            Padding(padding: EdgeInsets.all(10)),

            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(onPressed: () {

              },  style: ElevatedButton.styleFrom(
                backgroundColor: null,
              ), child: Text("New User? Click Here", style: TextStyle(fontSize: 24, color: Colors.lightBlue),)),
            ),

            Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(onPressed: () async {
                  bool isLogged = await login();
                  if(isLogged){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UltraSimpleCalendar()));
                  }
              },  style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.buttonBackgroundColor_alpha,
              ), child: Text("SIGN IN WITH GOOGLE", style: TextStyle(fontSize: 24, color: MainColors.titleTextColor),)),
            ),

            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, "/");
              },  style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white54,
              ), child: Text("BACK", style: TextStyle(fontSize: 24, color: MainColors.titleTextColor),)),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> login() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

}
