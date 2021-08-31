// To parse this JSON data, do
//
//     final reportedProductModel = reportedProductModelFromMap(jsonString);

import 'dart:convert';

class ReportedProductModel {
  ReportedProductModel({
    this.id,
    this.reportedBy,
    this.productId,
    this.reportedMessage,
    this.uploadedBy,
    this.status,
    this.resolvedBy,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? reportedBy;
  final int? productId;
  final String? reportedMessage;
  final int? uploadedBy;
  final String? status;
  final int? resolvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ReportedProductModel.fromJson(String str) => ReportedProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReportedProductModel.fromMap(Map<String, dynamic> json) => ReportedProductModel(
        id: int.tryParse(json["id"]),
        reportedBy: int.tryParse(json["reported_by"]),
        productId: int.tryParse(json["product_id"]),
        reportedMessage: json["reported_message"],
        uploadedBy: int.tryParse(json["uploaded_by"]),
        status: json["status"],
        resolvedBy: int.tryParse(json["resolved_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
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
