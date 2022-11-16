import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/model/modelclass.dart';
import 'package:posibolt_loyality/screens/widgets.dart';
import 'package:posibolt_loyality/services/services.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreference sharedPreference = SharedPreference();
  LoyalityUserData? loyalityUserData;
  late double screenwidth;
  late double screenheight;
  bool internetChecking = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    internetConnectionChecking();
    getLoyalityUserInformation();
  }

  void internetConnectionChecking() async{
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  Future getLoyalityUserInformation() async{
    String loyalityId = sharedPreference.getLoyaltyUsersBpartnerId().toString();
    var loyalityData = await ApiServices.getLoyalityUserData(loyalityId); ///dummy Loyalty ID : 60222978
    if( loyalityData is LoyalityUserData){
      setState(() {
        loyalityUserData = loyalityData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;

    if(internetChecking == true){
      return Scaffold(
        body: Container(
          height: screenheight * 1,
          width: screenwidth * 1,
          color: ThemeClass.backgroundColor,
          padding: EdgeInsets.only(left: screenwidth * 0.1,right: screenwidth * 0.1,bottom: 30,top: 60),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Material(
                        color: const Color(0xffE9E8EB),
                        child: InkWell(
                          splashColor: const Color(0xfff9f9f9),
                          onTap: () {
                            _bottomLogoutSheet(context,loyalityUserData!);
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: SvgPicture.asset("assets/images/usericon.svg",height: screenheight * 0.027)),
                        ),
                      ),
                    ),
                    Image.asset(ThemeClass.logoImages,width: screenwidth * 0.3,),
                    ClipOval(
                      child: Material(
                        color: const Color(0xffE9E8EB),
                        child: InkWell(
                          splashColor: const Color(0xfff9f9f9),
                          onTap: () async{
                            getLoyalityUserInformation();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Icon(Icons.refresh,size: screenheight * 0.027),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenheight * 0.035,),
                Container(
                  height: screenheight * 0.2,
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xfff45c43),
                        Color(0xffeb3349)
                      ],
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total  points",overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: "SourceSanProBold",fontSize:screenheight > ThemeClass.lowReslutionDevice ? 34:29,color: Colors.white),),
                          Text(loyalityUserData?.points == null ? "":loyalityUserData!.points.toString(),overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: "SourceSanProBold",fontSize:screenheight > ThemeClass.lowReslutionDevice ?  34 : 29,color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenheight > ThemeClass.lowReslutionDevice ? screenheight * 0.05:10.0,),
                Stack(
                  children: [
                    Container(
                      height: screenheight * 0.545,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36.0),
                        color: const Color(0xffE0E0EB),
                      ),
                      child:
                      Column(
                        children: [
                          Container(
                            height: screenheight * 0.185,
                            width: screenwidth * 1,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Text("Scan bar code",overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: "SourceSanProBold",fontSize:screenheight > ThemeClass.lowReslutionDevice ?  34 : 32, color: ThemeClass.boldTextColor),),
                                Text("Scan this code to redeem points",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize:screenheight > ThemeClass.lowReslutionDevice ?  15:14,color: ThemeClass.lightTextColor),),
                              ],
                            ),
                          ),
                          const DottedLine(),
                          Container(
                            width: screenwidth * 1,
                            height: screenheight * 0.345,
                            padding:  EdgeInsets.only(top:screenheight > ThemeClass.lowReslutionDevice ?  30 : 15,left: 20,right: 20,bottom: screenheight > ThemeClass.lowReslutionDevice ? 20 : 15),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  BarcodeWidget(
                                    barcode: Barcode.code128(useCode128B: true),
                                    data: loyalityUserData?.loyaltyNo == null ? "" : loyalityUserData!.loyaltyNo,
                                    height: screenheight * 0.22,
                                    width: screenheight * .22,
                                    drawText: false,
                                    textPadding: 10,
                                    color: Colors.black,
                                    margin: const EdgeInsets.all(10),
                                  ),
                                  SizedBox(height: screenheight > ThemeClass.lowReslutionDevice ?  7.0 : 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Or use",textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: 15,color: ThemeClass.lightTextColor),),
                                      const SizedBox(width: 10,),
                                      Image.asset("assets/images/handicon.png",height: 15,),
                                      const SizedBox(width: 10,),
                                      const Text(":",textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: 15,color:  ThemeClass.lightTextColor),),
                                      const SizedBox(width: 10,),
                                      const Text("Code - 128B",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: 15,color:  ThemeClass.lightTextColor),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: screenheight * 0.17,
                      left: -30,
                      child: const ClipOval(
                        child:  Material(
                          color: Color(0xffEDEDED), // Button color
                          child: SizedBox(width: 50, height: 30,),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenheight * 0.17,
                      right: -30,
                      child: const ClipOval(
                        child: Material(
                          color: Color(0xffEDEDED),
                          child: SizedBox(width: 50, height: 30,),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return Widgets.noInternetConnection(context);
    }
  }

///Logout Screen
  void _bottomLogoutSheet(BuildContext context,LoyalityUserData loyalityUserList) async{
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        builder: (builder) {
          return Container(
            padding:  EdgeInsets.only(left: screenwidth * 0.1, right: screenwidth * 0.1, top: 10.0, bottom: 15.0),
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SvgPicture.asset('assets/images/bottombarindicator.svg'),
                      ),
                      const SizedBox(height: 25.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10.0,),
                          ClipOval(
                            child: Material(
                              color: const Color(0xffE9E8EB),
                              child: InkWell(
                                splashColor: const Color(0xfff9f9f9),
                                child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: SvgPicture.asset("assets/images/usericon.svg",height: screenheight * 0.027,color: const Color(0xff8E8E93),)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15.0,),
                          Flexible(
                            child: Text(loyalityUserList.customerName.isEmpty ? "Default": loyalityUserList.customerName, overflow: TextOverflow.ellipsis,style: const TextStyle(fontFamily: 'SourceSansPro',fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xff8E8E93)),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22.0,),
                      Center(
                        child: SizedBox(
                          height: screenheight * 0.075,
                          width: screenwidth * 1,
                          child: ElevatedButton(
                            onPressed: () {
                              sharedPreference.eraseAllSharedPreferenceData();
                              Navigator.pushNamedAndRemoveUntil(context, "/loginscreen", (route) => false);
                            },
                            style: ElevatedButton.styleFrom(primary: ThemeClass.primaryColor, shape: const StadiumBorder()),
                            child:  const Text('Logout', style:  TextStyle(fontFamily: 'SourceSansPro',fontSize: 20,fontWeight: FontWeight.w500,color: Color(0xffffffff)),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
