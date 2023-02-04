// To parse this JSON data, do
//
//     final appUser = appUserFromMap(jsonString);

import 'dart:convert';

class AppUser {
  AppUser({
    this.userId,
    this.uid,
    this.name,
    this.email,
    this.mobileNumber,
    this.address,
    this.addressLat,
    this.addressLong,
    this.state,
    this.profilePhoto,
    this.deviceToken,
    this.notification,
    this.userLevel,
    this.onlineStatus,
    this.userAppVersion,
    this.baseCurrency,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  final String? userId;
  final String? uid;
  String? name;
  String? email;
  String? mobileNumber;
  String? address;
  double? addressLat;
  double? addressLong;
  String? state;
  String? profilePhoto;
  String? deviceToken;
  NotificationSetting? notification;
  int? userLevel;

  // int? radius;
  final String? onlineStatus;
  final String? userAppVersion;
  final String? baseCurrency;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AppUser.fromJson(String str) => AppUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppUser.fromMap(Map<String, dynamic> json) => AppUser(
        userId: json["user_id"],
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        address: json["address"],
        addressLat: json["address_lat"],
        addressLong: json["address_long"],
        state: json["state"],
        profilePhoto: json["profile_photo"],
        deviceToken: json["device_token"],
        notification: NotificationSetting.fromMap((json["notification"])),
        userLevel: json["user_level"],
        onlineStatus: json["online_status"],
        userAppVersion: json["user_app_version"],
        baseCurrency: json["base_currency"],
        lastLogin: DateTime.parse(json["last_login"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "uid": uid,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "address": address,
        "address_lat": addressLat,
        "address_long": addressLong,
        "state": state,
        "profile_photo": profilePhoto,
        "device_token": deviceToken,
        "notification": notification?.toMap(),
        "user_level": userLevel,
        "online_status": onlineStatus,
        "user_app_version": userAppVersion,
        "base_currency": baseCurrency,
        "last_login": lastLogin?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

//0-> OFF, 1-> ON
class NotificationSetting {
  NotificationSetting({
    this.general = true,
    this.call = true,
    this.chat = true,
    this.product = true,
  });

  bool general;
  bool call;
  bool chat;
  bool product;

  factory NotificationSetting.fromJson(String str) => NotificationSetting.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationSetting.fromMap(Map<String, dynamic> json) => NotificationSetting(
        general: json["general"],
        call: json["call"],
        chat: json["chat"],
        product: json["product"],
      );

  Map<String, dynamic> toMap() => {
        "general": general,
        "call": call,
        "chat": chat,
        "product": product,
      };
}
