import 'package:doit_list/StyleClasses/main_style.dart';
import 'package:flutter/material.dart';

class PopUpPage {

  void OpenNavMenu(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: MainColors.backgroundColor,
          appBar: AppBar(title: Text("Menu", style: TextStyle(color: MainColors.titleTextColor, fontSize: 54)), centerTitle: true, backgroundColor: MainColors.buttonBackgroundColor_beta,),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColors.buttonBackgroundColor_beta,
                ),
                child: Text("ON MAIN PAGE", style: TextStyle(color: MainColors.titleTextColor),),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text("MAIN MENU", style: TextStyle(color: MainColors.textColor),),
            ],
          ),
        );
      }),
    );
  }
}
