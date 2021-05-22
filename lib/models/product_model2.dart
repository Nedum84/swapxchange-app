// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

// Product productFromMap(String str) => Product.fromMap(json.decode(str));
//
// String productToMap(Product data) => json.encode(data.toMap());

List<Product2> productFromMap(String str) => List<Product2>.from(json.decode(str).map((x) => Product2.fromMap(x)));

String productToMap(List<Product2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Product2 {
  Product2({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  factory Product2.fromMap(Map<String, dynamic> json) => Product2(
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
