import 'dart:convert';

class ProductImage {
  ProductImage({
    this.id,
    this.productId,
    this.imagePath,
    this.idx,
  });

  final int? id;
  final int? productId;
  final String? imagePath;
  final int? idx;

  factory ProductImage.fromJson(String str) => ProductImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        productId: int.parse(json["product_id"].toString()),
        imagePath: json["image_path"],
        idx: json["idx"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_id": productId,
        "image_path": imagePath,
        "idx": idx,
      };
}
