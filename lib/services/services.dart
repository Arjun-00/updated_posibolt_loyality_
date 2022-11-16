import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:posibolt_loyality/%20constraints/urls.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/model/modelclass.dart';

class ApiServices{
  static  var client =http.Client();
  static Future<dynamic> loginDummyTockenGenerating() async {
    SharedPreference sharedPreference = SharedPreference();
    String url = Urls.dummyTockenGeneratingUrls;
    String credentials = "${Urls.dummyAppId}:${Urls.dummyAppSecret}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    try {
      Response response = await get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Basic $encoded"},
      );
      if (response.body != null)
      {
        Map data = jsonDecode(response.body);
        if (data['error'] != null) {
          return data['error_description'];
        } else if (data['access_token'] != null) {
          String access_token1 = json.decode(response.body)['access_token'];
          String access_tocken_type = json.decode(response.body)['token_type'];
          sharedPreference.saveTockenData(access_token1, access_tocken_type);
          return Token.setInstance(data, Urls.dummyUrls);
        } else {
          return "Service access denied";
        }
      } else {
        return "Unable to connect to server";
      }
    }
    catch(e) {
      return "Unable to connect to server";
    }
  }

  static Future<dynamic> getOtpVerification(String userPhonenumber) async{
    Token token = await loginDummyTockenGenerating();
    String Urles = "${Urls.otpGeneratingUrl}${userPhonenumber}";
    try{
      final response = await client.get(Uri.parse(Urles),headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "Authorization": "${token.token_type} ${token.access_token}"
      });
      if(response.statusCode == 200){
        ResponseClass responseClass = responseClassFromJson(response.body);
        return responseClass;
      }else{
        return "Server error";
      }
    }
    catch (e){
      return "Connection error";
    }
  }

  static Future<dynamic> matchOtpPhonenumber(String userPhonenumber,String otpNumber) async{
    Token token = await loginDummyTockenGenerating();
    String Urles = "${Urls.otpValidatingUrl}mobileno=${userPhonenumber}&otp=${otpNumber}";
    try{
      final response = await client.get(Uri.parse(Urles),headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "Authorization": "${token.token_type} ${token.access_token}"
      });
      if(response.statusCode == 200){
        LoyaltyUserPersonalInfo userData = loyaltyUserPersonalInfoFromJson(response.body);
        return userData;
      }else{
        return "Invalid OTP";
      }
    }
    catch (e){
      return "Unable to connect to server";
    }
  }

  static Future<dynamic> getLoyalityUserData(String customerId) async{
    Token token = await loginDummyTockenGenerating();
    try{
      final responce = await client.get(Uri.parse("${Urls.loyaltyUserDataUrl}${customerId}")
          , headers: { HttpHeaders.contentTypeHeader: "application/json",
            "Authorization": "${token.token_type} ${token.access_token}"});
      if(responce.statusCode == 200) {
        return loyalityUserDataFromJson(responce.body);
      } else{
        return "invalid request";
      }
    }catch(e){
      return "${e.toString()} +Error";
    }
  }
}