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
    this.onlineStatus,
    this.userAppVersion,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  final int? userId;
  final String? uid;
  final String? name;
  final String? email;
  final String? mobileNumber;
  final String? address;
  final String? addressLat;
  final String? addressLong;
  final String? state;
  final String? profilePhoto;
  final String? deviceToken;
  final String? onlineStatus;
  final String? userAppVersion;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AppUser.fromJson(String str) => AppUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppUser.fromMap(Map<String, dynamic> json) => AppUser(
        userId: int.parse(json["user_id"]),
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
        onlineStatus: json["online_status"],
        userAppVersion: json["user_app_version"],
        lastLogin: DateTime.parse(json["last_login"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "online_status": onlineStatus,
        "user_app_version": userAppVersion,
        "last_login": lastLogin?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
