// To parse this JSON data, do
//
//     final productChats = productChatsFromMap(jsonString);

import 'dart:convert';

class ProductChats {
  ProductChats({
    this.id,
    this.productId,
    this.offerProductId,
    this.senderId,
    this.receiverId,
    this.chatStatus,
  });

  final int? id;
  final int? productId;
  final int? offerProductId;
  final int? senderId;
  final int? receiverId;
  final SwapStatus? chatStatus;

  factory ProductChats.fromJson(String str) => ProductChats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductChats.fromMap(Map<String, dynamic> json) => ProductChats(
        id: int.parse(json["id"]),
        productId: int.parse(json["product_id"]),
        offerProductId: int.parse(json["offer_product_id"]),
        senderId: int.parse(json["sender_id"]),
        receiverId: int.parse(json["receiver_id"]),
        chatStatus: ProductChats.statusToEnum(json["chat_status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_id": productId,
        "offer_product_id": offerProductId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "chat_status": statusFromEnum(chatStatus!),
      };

  static SwapStatus statusToEnum(String status) {
    if (status == "open") {
      return SwapStatus.OPEN;
    } else if (status == "declined") {
      return SwapStatus.DECLINED;
    } else {
      return SwapStatus.EXCHANGED;
    }
  }

  String statusFromEnum(SwapStatus status) {
    if (status == SwapStatus.OPEN) {
      return "open";
    } else if (status == SwapStatus.DECLINED) {
      return "declined";
    } else {
      return "exchanged";
    }
  }
}

enum SwapStatus { OPEN, DECLINED, EXCHANGED }
