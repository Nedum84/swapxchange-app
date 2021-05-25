import 'dart:convert';

class ChatMessage {
  ChatMessage({
    this.id,
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.photoUrl,
    this.timestamp,
    this.productChatId,
    this.isRead = false,
  });

  final String? id;
  final int? senderId;
  final int? receiverId;
  final String? type;
  String? message;
  String? photoUrl;
  final int? timestamp;
  final int? productChatId;
  final bool isRead;

  factory ChatMessage.fromJson(String str) => ChatMessage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromMap(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        type: json["type"],
        message: json["message"],
        photoUrl: json["photo_url"],
        timestamp: json["timestamp"],
        productChatId: json["product_chat_id"],
        isRead: json["is_read"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "type": type,
        "message": message,
        "photo_url": photoUrl,
        "timestamp": timestamp,
        "product_chat_id": productChatId,
        "is_read": isRead,
      };
}

class ChatMessageType {
  static const String TEXT = "text";
  static const String IMAGE = "image";
  static const String PRODUCT_CHAT = "productChat";
}
