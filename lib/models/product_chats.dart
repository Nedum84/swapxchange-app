// To parse this JSON data, do
//
//     final productChats = productChatsFromMap(jsonString);

import 'dart:convert';

import 'package:swapxchange/models/product_image.dart';

class ProductChats {
  ProductChats({
    this.productChatId,
    this.productId,
    this.offerProductId,
    this.senderId,
    this.receiverId,
    this.senderClosedDeal,
    this.receiverClosedDeal,
    this.chatStatus,
    this.productImages,
    this.productOfferImages,
  });

  final String? productChatId;
  final String? productId;
  final String? offerProductId;
  final String? senderId;
  final String? receiverId;
  bool? senderClosedDeal;
  bool? receiverClosedDeal;
  SwapStatus? chatStatus;
  final List<ProductImage>? productImages;
  final List<ProductImage>? productOfferImages;

  factory ProductChats.fromJson(String str) => ProductChats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductChats.fromMap(Map<String, dynamic> json) => ProductChats(
        productChatId: json["product_chat_id"],
        productId: json["product_id"],
        offerProductId: json["offer_product_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        senderClosedDeal: json["sender_closed_deal"],
        receiverClosedDeal: json["receiver_closed_deal"],
        chatStatus: ProductChats.statusToEnum(json["chat_status"]),
        productImages: List<ProductImage>.from(json["product_images"]?.map((x) => ProductImage.fromMap(x))),
        productOfferImages: List<ProductImage>.from(json["product_offer_images"]?.map((x) => ProductImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "product_chat_id": productChatId,
        "product_id": productId,
        "offer_product_id": offerProductId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "sender_closed_deal": senderClosedDeal,
        "receiver_closed_deal": receiverClosedDeal,
        "chat_status": statusFromEnum(chatStatus!),
        "product_images": List<dynamic>.from(productImages?.map((x) => x.toMap()) ?? []),
        "product_offer_images": List<dynamic>.from(productOfferImages?.map((x) => x.toMap()) ?? []),
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
