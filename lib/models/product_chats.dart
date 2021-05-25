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
  final String? chatStatus;

  factory ProductChats.fromJson(String str) => ProductChats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductChats.fromMap(Map<String, dynamic> json) => ProductChats(
        id: json["id"],
        productId: json["product_id"],
        offerProductId: json["offer_product_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        chatStatus: json["chat_status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_id": productId,
        "offer_product_id": offerProductId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "chat_status": chatStatus,
      };
}
