// To parse this JSON data, do
//
//     final reportedProductModel = reportedProductModelFromMap(jsonString);

import 'dart:convert';

class ReportedProductModel {
  ReportedProductModel({
    this.reportedId,
    this.reportedBy,
    this.productId,
    this.reportedMessage,
    this.uploadedBy,
    this.status,
    this.resolvedBy,
    this.createdAt,
    this.updatedAt,
  });

  final String? reportedId;
  final String? reportedBy;
  final String? productId;
  final String? reportedMessage;
  final String? uploadedBy;
  final String? status;
  final String? resolvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ReportedProductModel.fromJson(String str) => ReportedProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReportedProductModel.fromMap(Map<String, dynamic> json) => ReportedProductModel(
        reportedId: json["reported_id"],
        reportedBy: json["reported_by"],
        productId: json["product_id"],
        reportedMessage: json["reported_message"],
        uploadedBy: json["uploaded_by"],
        status: json["status"],
        resolvedBy: json["resolved_by"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "reported_id": reportedId,
        "reported_by": reportedBy,
        "product_id": productId,
        "reported_message": reportedMessage,
        "uploaded_by": uploadedBy,
        "status": status,
        "resolved_by": resolvedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
