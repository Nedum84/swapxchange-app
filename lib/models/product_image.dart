import 'dart:convert';

class ProductImage {
  ProductImage({
    this.imageId,
    this.productId,
    this.imagePath,
    this.idx,
  });

  final String? imageId;
  String? productId;
  final String? imagePath;
  int? idx;

  bool isCurrent = false;

  factory ProductImage.fromJson(String str) => ProductImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        imageId: json["image_id"].toString(),
        productId: json["product_id"].toString(),
        imagePath: json["image_path"],
        idx: json["idx"],
      );

  Map<String, dynamic> toMap() => {
        "image_id": imageId,
        "product_id": productId,
        "image_path": imagePath,
        "idx": idx,
      };
}
