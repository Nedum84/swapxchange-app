// To parse this JSON data, do
//
//     final faqModel = faqModelFromMap(jsonString);

import 'dart:convert';

class FaqModel {
  FaqModel({
    this.faqId,
    this.question,
    this.answer,
    this.category,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  final int? faqId;
  final String? question;
  final String? answer;
  final String? category;
  final int? addedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FaqModel.fromJson(String str) => FaqModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FaqModel.fromMap(Map<String, dynamic> json) => FaqModel(
        faqId: int.tryParse(json["faq_id"]),
        question: json["question"],
        answer: json["answer"],
        category: json["category"],
        addedBy: int.tryParse(json["added_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "faq_id": faqId,
        "question": question,
        "answer": answer,
        "category": category,
        "added_by": addedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
