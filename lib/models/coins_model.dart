import 'dart:convert';

class CoinsModel {
  CoinsModel({
    this.totalCoins,
    this.totalUploadAmount,
    this.totalTransfers,
    this.balance,
    this.lastCredit,
    this.meta,
  });

  final int? totalCoins;
  final int? totalUploadAmount;
  final int? totalTransfers;
  final int? balance;
  final LastCredit? lastCredit;
  final List<LastCredit>? meta;

  factory CoinsModel.fromJson(String str) => CoinsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoinsModel.fromMap(Map<String, dynamic> json) => CoinsModel(
        totalCoins: json["total_coins"],
        totalUploadAmount: json["total_upload_amount"],
        totalTransfers: json["total_transfers"],
        balance: json["balance"],
        lastCredit: json["last_credit"] == null ? null : LastCredit.fromMap(json["last_credit"]),
        meta: json["meta"] == null ? [] : List<LastCredit>.from(json["meta"]?.map((x) => LastCredit.fromMap(x))),
        // meta: null,
      );

  Map<String, dynamic> toMap() => {
        "total_coins": totalCoins,
        "total_upload_amount": totalUploadAmount,
        "total_transfers": totalTransfers,
        "balance": balance,
        "last_credit": lastCredit?.toMap(),
        "meta": List<dynamic>.from(meta?.map((x) => x.toMap()) ?? []),
      };
}

class LastCredit {
  LastCredit({
    this.id,
    this.userId,
    this.amount,
    this.reference,
    this.methodOfSubscription,
    this.createdAt,
  });

  final int? id;
  final int? userId;
  final int? amount;
  final String? reference;
  final MethodOfSubscription? methodOfSubscription;
  final DateTime? createdAt;

  factory LastCredit.fromJson(String str) => LastCredit.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LastCredit.fromMap(Map<String, dynamic> json) => LastCredit(
        id: int.tryParse(json["id"]),
        userId: int.tryParse(json["user_id"]),
        amount: int.tryParse(json["amount"]),
        reference: json["reference"],
        methodOfSubscription: LastCredit.statusToEnum(json["method_of_subscription"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "amount": amount,
        "reference": reference,
        "method_of_subscription": LastCredit.statusFromEnum(methodOfSubscription!),
        "created_at": createdAt!.toIso8601String(),
      };

  static MethodOfSubscription statusToEnum(String status) {
    if (status == "registration") {
      return MethodOfSubscription.REGISTRATION;
    } else if (status == "purchase") {
      return MethodOfSubscription.PURCHASE;
    } else if (status == "watch_video") {
      return MethodOfSubscription.WATCH_VIDEO;
    } else if (status == "daily_opening") {
      return MethodOfSubscription.DAILY_OPENING;
    } else if (status == "invitation") {
      return MethodOfSubscription.INVITATION;
    } else if (status == "transfer") {
      return MethodOfSubscription.TRANSFER;
    } else if (status == "coupon") {
      return MethodOfSubscription.COUPON;
    } else {
      return MethodOfSubscription.REGISTRATION;
    }
  }

  static String statusFromEnum(MethodOfSubscription status) {
    if (status == MethodOfSubscription.REGISTRATION) {
      return "registration";
    } else if (status == MethodOfSubscription.PURCHASE) {
      return "purchase";
    } else if (status == MethodOfSubscription.WATCH_VIDEO) {
      return "watch_video";
    } else if (status == MethodOfSubscription.DAILY_OPENING) {
      return "daily_opening";
    } else if (status == MethodOfSubscription.INVITATION) {
      return "invitation";
    } else if (status == MethodOfSubscription.TRANSFER) {
      return "transfer";
    } else if (status == MethodOfSubscription.COUPON) {
      return "coupon";
    } else {
      return "registration";
    }
  }

  static String statusFromEnum2(MethodOfSubscription status) {
    if (status == MethodOfSubscription.REGISTRATION) {
      return "Registration";
    } else if (status == MethodOfSubscription.PURCHASE) {
      return "Purchase";
    } else if (status == MethodOfSubscription.WATCH_VIDEO) {
      return "Rewarded Video";
    } else if (status == MethodOfSubscription.DAILY_OPENING) {
      return "Daily Coins";
    } else if (status == MethodOfSubscription.INVITATION) {
      return "Invitation";
    } else if (status == MethodOfSubscription.TRANSFER) {
      return "Transfer";
    } else if (status == MethodOfSubscription.COUPON) {
      return "Coupon code";
    } else {
      return "Registration";
    }
  }
}

//--> Method of subscription
enum MethodOfSubscription {
  REGISTRATION,
  PURCHASE,
  WATCH_VIDEO,
  DAILY_OPENING,
  INVITATION,
  TRANSFER,
  COUPON,
}
