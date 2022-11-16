import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/model/modelclass.dart';
import 'package:posibolt_loyality/services/services.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';
import '../../ constraints/urls.dart';
import '../widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreference sharedPreference = SharedPreference();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late double screenwidth;
  late double screenheight;
  String? errorMessage;
  bool internetChecking = true;

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    countryCodeController.text = Urls.usersContryCode;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.clear();
    errorMessage = null;
  }

  void internetConnectionChecking() async{
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    if (internetChecking == true){
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: screenheight * 1,
            width: screenwidth * 1,
            color: ThemeClass.backgroundColor,
            padding: EdgeInsets.only(left: screenwidth * 0.1,right: screenwidth * 0.1,bottom: 30,top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/homescreen.svg",height: screenheight * 0.35,),
                Image.asset(ThemeClass.logoImages,width: screenwidth * 0.53,),
                SizedBox(height: screenwidth * 0.04,),
                Column(
                  children: [
                    const Text("Sign in",style: TextStyle(fontFamily: "SourceSansPro",fontSize: 38,color: ThemeClass.boldTextColor,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20.0,),
                    const Text("We send a verification code \n to your number",overflow: TextOverflow.fade,textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: 15,color: ThemeClass.lightTextColor),),
                    SizedBox(height: screenwidth * 0.025,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: screenheight > ThemeClass.lowReslutionDevice ?screenheight * 0.07 : 52,
                      width: screenwidth * 0.2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14),topLeft: Radius.circular(14) ),
                      ),
                      child: TextField(
                        controller: countryCodeController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontFamily: 'SourceSansPro',fontSize: 27,fontWeight: FontWeight.w500,color: Color(0xff342914)),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: screenheight > ThemeClass.lowReslutionDevice ? screenheight * 0.07 : 52,
                      width: screenwidth * 0.59,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(14),bottomRight: Radius.circular(14) ),
                      ),
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        style:  TextStyle(fontFamily: 'SourceSansPro',fontSize: screenheight > ThemeClass.lowReslutionDevice ?  27 : 27,fontWeight: FontWeight.w500,color: const Color(0xff342914)),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(left: 20.0,right: 20.0 ),),
                      ),
                    ),
                  ],
                ),
                screenheight > ThemeClass.lowReslutionDevice ? const SizedBox() : const SizedBox(height: 10,),
                Center(
                  child: SizedBox(
                    height: screenheight > ThemeClass.lowReslutionDevice ? screenheight * 0.075 : 50,
                    width: screenwidth * 1,
                    child: ElevatedButton(
                      onPressed: () async{
                           bool connectionChecking= await InternetConnectionChecker().hasConnection;
                           setState(() {
                             internetChecking = connectionChecking;
                           });
                        if(internetChecking == false){
                          Widgets.noInternetConnection(context);
                        }else{
                          if(phoneNumberController.text.length > 8){
                            String phonenumber = phoneNumberController.text;
                            var otpVerificationResponce = await ApiServices.getOtpVerification(phonenumber);
                            if(otpVerificationResponce is ResponseClass)
                            {
                              if(otpVerificationResponce.responseCode != 200){
                                setState(() {
                                  errorMessage = otpVerificationResponce.detailedMessage.toString();
                                });
                              }else{
                                Navigator.pushNamed(context, "/otpscreen",arguments: {'phoneNumbers' : phonenumber});
                              }
                            }
                            else{
                              setState(() {
                                errorMessage = otpVerificationResponce.toString();
                              });
                            }
                          }else{
                            setState(() {
                              errorMessage = "Please enter a valid phone number";
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: ThemeClass.primaryColor, shape: const StadiumBorder()),
                      child: const Text('Get OTP',style: TextStyle(color: Color(0xfff2f2f2),fontFamily: 'SourceSansPro',fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                errorMessage == null ? const SizedBox():Text(errorMessage!,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );
    }else{
      return Widgets.noInternetConnection(context);
    }
  }
}
