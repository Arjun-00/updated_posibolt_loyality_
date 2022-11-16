import 'dart:async';
import 'package:flutter/material.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  late double screenwidth;
  late double screenheight;
  SharedPreference sharedPreference = SharedPreference();

  void checkLoginAndVanigate(BuildContext context) async {
    try{
      int? _bPartnerId = sharedPreference.getLoyaltyUsersBpartnerId();
      if(_bPartnerId != null && _bPartnerId != 0){
        Navigator.popAndPushNamed(context, "/homescreen");
      }else{
        Navigator.popAndPushNamed(context, "/loginscreen");
      }
    }catch (e){
      Navigator.popAndPushNamed(context, "/loginscreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    Future.delayed(Duration(seconds: 2),() => checkLoginAndVanigate(context));
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(ThemeClass.logoImages,width: screenwidth * 0.6,),
        ),
      ),
    );
  }
}
