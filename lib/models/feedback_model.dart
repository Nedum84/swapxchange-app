// To parse this JSON data, do
//
//     final feedbackModel = feedbackModelFromMap(jsonString);

import 'dart:convert';

class FeedbackModel {
  FeedbackModel({
    this.id,
    this.userId,
    this.message,
    this.status,
    this.resolvedBy,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? message;
  final String? status;
  final String? resolvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FeedbackModel.fromJson(String str) => FeedbackModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FeedbackModel.fromMap(Map<String, dynamic> json) => FeedbackModel(
        id: json["id"],
        userId: json["user_id"],
        message: json["message"],
        status: json["status"],
        resolvedBy: json["resolved_by"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "message": message,
        "status": status,
        "resolved_by": resolvedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
