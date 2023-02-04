import 'dart:convert';

class NotificationModel {
  NotificationModel({
    this.priority = "high",
    this.notification,
    this.data,
    this.userId,
    this.dateCreated,
    this.isRead = false,
    this.docId,
  });

  final String priority;
  final PushNotification? notification;
  final NotificationData? data;
  final String? userId; // The user this is being sent for
  final DateTime? dateCreated;
  final bool? isRead;
  final String? docId;

  factory NotificationModel.fromJson(String str) => NotificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
        priority: json["priority"],
        notification: PushNotification.fromMap(json["notification"]),
        data: NotificationData.fromMap(json["data"]),
        userId: json["user_id"] ?? 0,
        dateCreated: DateTime.tryParse(json["date_created"].toString()) ?? DateTime.now(),
        isRead: json["is_read"] ?? false,
        docId: json["doc_id"] ?? "sxwapxchange",
      );

  Map<String, dynamic> toMap() => {
        "priority": priority,
        "notification": notification?.toMap(),
        "data": data?.toMap(),
        "user_id": userId,
        "date_created": dateCreated,
        "is_read": isRead,
        "doc_id": docId,
      };
}

class NotificationData {
  NotificationData({
    this.clickAction = 'FLUTTER_NOTIFICATION_CLICK',
    this.title,
    this.body,
    this.id,
    this.idSecondary,
    this.type = NotificationType.CHAT,
    this.payload = "",
  });

  final String clickAction;
  final String? title;
  final String? body;
  final String? id;
  final String? idSecondary;
  final NotificationType? type;
  final String payload;

  factory NotificationData.fromJson(String str) => NotificationData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationData.fromMap(Map<String, dynamic> json) => NotificationData(
        clickAction: json["click_action"],
        title: json["title"],
        body: json["body"],
        id: json["id"],
        idSecondary: json["id_secondary"],
        type: typeToEnum(json["type"]),
        payload: json["payload"],
      );

  Map<String, dynamic> toMap() => {
        "click_action": clickAction,
        "title": title,
        "body": body,
        "id": id,
        "id_secondary": idSecondary,
        "type": typeFromEnum(type!),
        "payload": payload,
        "content_available": true,
        "priority": "normal",
      };

  static NotificationType typeToEnum(String status) {
    if (status == "chat") {
      return NotificationType.CHAT;
    } else if (status == "call") {
      return NotificationType.CALL;
    } else if (status == "product") {
      return NotificationType.PRODUCT;
    } else {
      return NotificationType.PRODUCT;
    }
  }

  static String typeFromEnum(NotificationType type) {
    if (type == NotificationType.CHAT) {
      return "chat";
    } else if (type == NotificationType.CALL) {
      return "call";
    } else if (type == NotificationType.PRODUCT) {
      return "product";
    } else {
      return "product";
    }
  }
}

class PushNotification {
  PushNotification({
    this.body,
    this.title,
  });

  final String? body;
  final String? title;

  factory PushNotification.fromJson(String str) => PushNotification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PushNotification.fromMap(Map<String, dynamic> json) => PushNotification(
        body: json["body"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "body": body,
        "title": title,
      };
}

//--> Product Status
enum NotificationType {
  CHAT,
  PRODUCT,
  CALL,
}
