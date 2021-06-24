// To parse this JSON data, do
//
//     final subCategory = subCategoryFromMap(jsonString);

import 'dart:convert';

class SubCategory {
  SubCategory({
    this.subCategoryId,
    this.subCategoryName,
    this.subCategoryIcon,
    this.categoryId,
    this.idx,
    this.createdAt,
    this.updatedAt,
    this.noOfProducts,
  });

  final int? subCategoryId;
  String? subCategoryName;
  String? subCategoryIcon;
  final int? categoryId;
  final int? idx;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? noOfProducts;

  factory SubCategory.fromJson(String str) => SubCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategory.fromMap(Map<String, dynamic> json) => SubCategory(
        subCategoryId: int.parse(json["sub_category_id"]),
        subCategoryName: json["sub_category_name"],
        subCategoryIcon: json["sub_category_icon"],
        categoryId: int.parse(json["category_id"]),
        idx: int.parse(json["idx"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        noOfProducts: int.parse(json["no_of_products"]),
      );

  Map<String, dynamic> toMap() => {
        "sub_category_id": subCategoryId,
        "sub_category_name": subCategoryName,
        "sub_category_icon": subCategoryIcon,
        "category_id": categoryId,
        "idx": idx,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "no_of_products": noOfProducts,
      };
}
