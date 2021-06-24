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
        categoryId: int.parse(json["category_id"].toString()),
        categoryName: json["category_name"],
        categoryIcon: json["category_icon"],
        idx: int.parse(json["idx"] == null ? "0" : json["idx"]), //---> Idx could be null from product list suggestions that only depends on id, icon & cat name
        noOfProducts: int.parse(json["no_of_products"] == null ? "0" : json["no_of_products"]),
        createdAt: DateTime.parse(json["created_at"] == null ? "2021-05-23 20:12:15" : json["created_at"]), //---> Dummy date ==2021-05-23 20:12:15
        updatedAt: DateTime.parse(json["updated_at"] == null ? "2021-05-23 20:12:15" : json["updated_at"]), //---> Dummy date ==2021-05-23 20:12:15
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
