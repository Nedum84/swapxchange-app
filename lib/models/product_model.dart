// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

// Product productFromMap(String str) => Product.fromMap(json.decode(str));
//
// String productToMap(Product data) => json.encode(data.toMap());

List<Product> productFromMap(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromMap(x)));

String productToMap(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Product {
  Product({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        userId: json["userId"],
        id: json["id"],
        title: json["title"].toString(),
        body: json["body"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
