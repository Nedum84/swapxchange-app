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

  final String? subCategoryId;
  String? subCategoryName;
  String? subCategoryIcon;
  final String? categoryId;
  final int? idx;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? noOfProducts;

  factory SubCategory.fromJson(String str) => SubCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategory.fromMap(Map<String, dynamic> json) => SubCategory(
        subCategoryId: json["sub_category_id"],
        subCategoryName: json["sub_category_name"],
        subCategoryIcon: json["sub_category_icon"],
        categoryId: json["category_id"],
        idx: json["idx"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        noOfProducts: json["no_of_products"] == null ? 0 : json["no_of_products"],
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
