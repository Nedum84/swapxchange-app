import 'dart:convert';

class ProductImage {
  ProductImage({
    this.id,
    this.productId,
    this.imagePath,
    this.idx,
  });

  final int? id;
  int? productId;
  final String? imagePath;
  int? idx;

  bool isCurrent = false;

  factory ProductImage.fromJson(String str) => ProductImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        id: int.tryParse(json["id"].toString()),
        productId: int.tryParse(json["product_id"].toString()),
        imagePath: json["image_path"],
        idx: int.tryParse(json["idx"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_id": productId,
        "image_path": imagePath,
        "idx": idx,
      };
}
