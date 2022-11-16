import 'dart:convert';

class Token {
  String access_token;
  String token_type;
  int expires_in;
  DateTime? createTime;
  String? url;

  Token({required this.access_token,required this.token_type,required this.expires_in});

  static Token setInstance (Map map, String url) {
    Token token = Token(access_token:map['access_token'],token_type:map['token_type'],expires_in:map['expires_in']);
    token.createTime = DateTime.now();
    token.url = url;
    return token;
  }
  bool isValid() {
    DateTime time = DateTime.now();
    Duration duration = time.difference(createTime!);
    return duration.inSeconds <= expires_in;
  }
}

ResponseClass responseClassFromJson(String str) => ResponseClass.fromJson(json.decode(str));
String responseClassToJson(ResponseClass data) => json.encode(data.toJson());

class ResponseClass {
  ResponseClass({
    required this.responseCode,
    required this.detailedMessage,
    this.record,
    this.recordNo,
    required this.message,
  });

  int responseCode;
  String detailedMessage;
  dynamic record;
  dynamic recordNo;
  String message;

  factory ResponseClass.fromJson(Map<String, dynamic> json) => ResponseClass(
    responseCode: json["responseCode"],
    detailedMessage: json["detailedMessage"],
    record: json["record"],
    recordNo: json["recordNo"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "detailedMessage": detailedMessage,
    "record": record,
    "recordNo": recordNo,
    "message": message,
  };
}

LoyaltyUserPersonalInfo loyaltyUserPersonalInfoFromJson(String str) => LoyaltyUserPersonalInfo.fromJson(json.decode(str));
String loyaltyUserPersonalInfoToJson(LoyaltyUserPersonalInfo data) => json.encode(data.toJson());

class LoyaltyUserPersonalInfo {
  LoyaltyUserPersonalInfo({
    this.name,
    this.lastname,
    this.bpartnerId,
    this.bpartnerValue,
    this.loyaltyNo,
  });

  String? name;
  String? lastname;
  int? bpartnerId;
  String? bpartnerValue;
  String? loyaltyNo;
  factory LoyaltyUserPersonalInfo.fromJson(Map<String, dynamic> json) => LoyaltyUserPersonalInfo(
    name: json["name"],
    lastname: json["lastname"],
    bpartnerId: json["bpartnerId"],
    bpartnerValue: json["bpartnerValue"],
    loyaltyNo: json["loyaltyNo"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lastname": lastname,
    "bpartnerId": bpartnerId,
    "bpartnerValue": bpartnerValue,
    "loyaltyNo": loyaltyNo,
  };
}

LoyalityUserData loyalityUserDataFromJson(String str) => LoyalityUserData.fromJson(json.decode(str));
String loyalityUserDataToJson(LoyalityUserData data) => json.encode(data.toJson());

class LoyalityUserData {
  LoyalityUserData({
    required this.phone,
    required this.loyaltyNo,
    required this.phone2,
    required this.customerName,
    required this.points,
  });

  String phone;
  String loyaltyNo;
  String phone2;
  String customerName;
  double points;

  factory LoyalityUserData.fromJson(Map<String, dynamic> json) => LoyalityUserData(
    phone: json["phone"],
    loyaltyNo: json["loyaltyNo"],
    phone2: json["phone2"],
    customerName: json["customerName"],
    points: double.parse(json["points"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "loyaltyNo": loyaltyNo,
    "phone2": phone2,
    "customerName": customerName,
    "points": points,
  };
}


