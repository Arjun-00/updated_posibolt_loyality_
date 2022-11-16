class Urls{
  static const usersContryCode = "+971";
  static const baseUrls = "http://testclt70.posibolt.org";
  static const otpGeneratingUrl = "$baseUrls/AdempiereService/PosiboltRest/otp/generateotp/";
  static const otpValidatingUrl = "$baseUrls/AdempiereService/PosiboltRest/otp/match?";
  static const loyaltyUserDataUrl = "$baseUrls/AdempiereService/PosiboltRest/customerloyaltymaster/loyaltypoints?customerId=";
  static const dummyTockenGeneratingUrls = "$dummyUrls/AdempiereService/oauth/token?username=${dummyUsername}&password=${dummyPassword}&grant_type=password&terminal=${dummyTerminal}";

  ///Dummy User Information
  static const String dummyUsername = "Juventus Admin";
  static const String dummyPassword = "juve";
  static const String dummyUrls = "http://testclt70.posibolt.org";
  static const String dummyAppId = "juve";
  static const String dummyAppSecret = "juve123";
  static const String dummyTerminal = "Terminal 1";
}