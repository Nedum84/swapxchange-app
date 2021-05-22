import 'dart:convert';

class Product {
  Product({
    this.productId,
    this.orderId,
    this.productName,
    this.category,
    this.subCategory,
    this.price,
    this.productDescription,
    this.productSuggestion,
    this.productCondition,
    this.productStatus,
    this.userId,
    this.userAddress,
    this.userAddressCity,
    this.userAddressLat,
    this.userAddressLong,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.user,
  });

  final int? productId;
  final String? orderId;
  String? productName;
  final int? category;
  final int? subCategory;
  final int? price;
  final String? productDescription;
  final String? productSuggestion;
  final String? productCondition;
  final int? productStatus;
  final int? userId;
  final String? userAddress;
  final String? userAddressCity;
  final String? userAddressLat;
  final String? userAddressLong;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ProductImage>? images;
  final Poster? user;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        productId: int.parse(json["product_id"]),
        orderId: json["order_id"],
        productName: json["product_name"],
        category: int.parse(json["category"]),
        subCategory: int.parse(json["sub_category"]),
        price: int.parse(json["price"]),
        productDescription: json["product_description"],
        productSuggestion: json["product_suggestion"],
        productCondition: json["product_condition"],
        productStatus: int.parse(json["product_status"]),
        userId: int.parse(json["user_id"]),
        userAddress: json["user_address"],
        userAddressCity: json["user_address_city"],
        userAddressLat: json["user_address_lat"],
        userAddressLong: json["user_address_long"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        images: List<ProductImage>.from(jsonDecode(json["images"]).map((x) => ProductImage.fromMap(x))),
        // images: jsonDecode(json['images']).map<ProductImage>((j) => ProductImage.fromJson(j)).toList(),
        user: Poster.fromMap(jsonDecode(json["user"])),
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "order_id": orderId,
        "product_name": productName,
        "category": category,
        "sub_category": subCategory,
        "price": price,
        "product_description": productDescription,
        "product_suggestion": productSuggestion,
        "product_condition": productCondition,
        "product_status": productStatus,
        "user_id": userId,
        "user_address": userAddress,
        "user_address_city": userAddressCity,
        "user_address_lat": userAddressLat,
        "user_address_long": userAddressLong,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "images": List<dynamic>.from(images!.map((x) => x.toMap())),
        "user": user!.toMap(),
      };
}

class ProductImage {
  ProductImage({
    this.id,
    this.productId,
    this.imagePath,
    this.idx,
  });

  final int? id;
  final String? productId;
  final String? imagePath;
  final int? idx;

  factory ProductImage.fromJson(String str) => ProductImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        productId: json["product_id"],
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

class Poster {
  Poster({
    this.userId,
    this.name,
    this.mobileNumber,
    this.address,
    this.profilePhoto,
  });

  final int? userId;
  final String? name;
  final String? mobileNumber;
  final String? address;
  final String? profilePhoto;

  factory Poster.fromJson(String str) => Poster.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Poster.fromMap(Map<String, dynamic> json) => Poster(
        userId: json["user_id"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        address: json["address"],
        profilePhoto: json["profile_photo"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "name": name,
        "mobile_number": mobileNumber,
        "address": address,
        "profile_photo": profilePhoto,
      };
}
