// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'dart:convert';

class Category {
  Category({
    this.categoryId,
    this.categoryName,
    this.categoryIcon,
    this.idx,
    this.noOfProducts,
    this.createdAt,
    this.updatedAt,
  });

  final int? categoryId;
  final String? categoryName;
  final String? categoryIcon;
  final int? idx;
  final int? noOfProducts;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        categoryId: int.parse(json["category_id"]),
        categoryName: json["category_name"],
        categoryIcon: json["category_icon"],
        idx: int.parse(json["idx"]),
        noOfProducts: int.parse(json["no_of_products"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_icon": categoryIcon,
        "idx": idx,
        "no_of_products": noOfProducts,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
