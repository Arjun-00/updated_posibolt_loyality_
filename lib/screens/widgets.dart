import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Widgets{
  static Widget noInternetConnection(BuildContext context){
    bool internetChecking = false;
    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,right: MediaQuery.of(context).size.width * 0.1,bottom: 30,top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/nointernetconn.svg",height:  MediaQuery.of(context).size.height * 0.2,color: Color(0xffDB283E),),
            SizedBox(height: 20.0,),
            Text("No connection!",style: TextStyle(fontFamily: "SourceSanProBold",fontSize: 34,color: Color(0xff383838)),),
            SizedBox(height: 15.0,),
            Text("Please check your internet connectivity\nand try again",textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: 15,color: Color(0xff818181)),),
            SizedBox(height: 30.0,),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.055,
                width: MediaQuery.of(context).size.width * 0.3 ,
                child: ElevatedButton(
                  onPressed: () async {
                    internetChecking = await InternetConnectionChecker().hasConnection;
                    if(internetChecking == true){
                      Navigator.pushNamedAndRemoveUntil(context, "/loginscreen", (route) => false);
                    }
                  },
                  child: Text('Retry',style: TextStyle(color: Color(0xfff2f2f2),fontFamily: 'SourceSansPro',fontSize: 20,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(primary: const Color(0xffDB283E), shape: const StadiumBorder()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
