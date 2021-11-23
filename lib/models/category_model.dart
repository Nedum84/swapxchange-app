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

  final String? categoryId;
  String? categoryName;
  String? categoryIcon;
  final int? idx;
  final int? noOfProducts;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  shortCatName() => categoryName!.length > 10 ? categoryName!.substring(0, 9) + "..." : categoryName;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryIcon: json["category_icon"],
        idx: json["idx"], //---> Idx could be null from product list suggestions that only depends on id, icon & cat name
        noOfProducts: json["no_of_products"] == null ? 0 : json["no_of_products"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_icon": categoryIcon,
        "idx": idx,
        "no_of_products": noOfProducts,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
