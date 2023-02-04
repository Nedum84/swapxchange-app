import 'dart:convert';

import 'package:swapxchange/extensions/list_extensions.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/product_image.dart';

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
    this.distance,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.user,
    this.suggestions,
    this.uploadPrice,
    this.noOfViews,
  });

  final String? productId;
  final String? orderId;
  String? productName;
  String? category;
  String? subCategory;
  int? price;
  String? productDescription;
  List? productSuggestion;
  final String? productCondition;
  ProductStatus? productStatus;
  final String? userId;
  final String? userAddress;
  final String? userAddressCity;
  final double? userAddressLat;
  final double? userAddressLong;
  final double? distance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  List<ProductImage>? images;
  final Poster? user;
  final List<Category>? suggestions;
  final int? uploadPrice;
  final int? noOfViews;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  static List<ProductImage> setImages(Map<String, dynamic> json) {
    final List<ProductImage> images = List<ProductImage>.from(json["images"].map((x) => ProductImage.fromMap(x)));
    return images.sortedDescBy((it) => it.idx!) as List<ProductImage>;
  }

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        orderId: json["order_id"],
        productName: json["product_name"],
        category: json["category"] != null ? json["category"] : json["Category"],
        subCategory: json["sub_category"],
        price: json["price"],
        productDescription: json["product_description"],
        productSuggestion: json["product_suggestion"],
        productCondition: json["product_condition"],
        productStatus: Product.statusToEnum(int.tryParse(json["product_status"]) ?? json["product_status"]),
        userId: json["user_id"],
        userAddress: json["user_address"],
        userAddressCity: json["user_address_city"],
        userAddressLat: json["user_address_lat"],
        userAddressLong: json["user_address_long"],
        distance: json["distance"] == null ? 0 : (json["distance"]).toDouble() ?? json["distance"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        // images: List<ProductImage>.from(json["images"].map((x) => ProductImage.fromMap(x))),
        images: setImages(json),
        suggestions: List<Category>.from(json["suggestions"].map((x) => Category.fromMap(x))),
        user: Poster.fromMap(json["user"]),
        uploadPrice: json["upload_price"],
        noOfViews: json["no_of_views"],
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
        "product_status": Product.statusFromEnum(productStatus!),
        "user_id": userId,
        "user_address": userAddress,
        "user_address_city": userAddressCity,
        "user_address_lat": userAddressLat,
        "user_address_long": userAddressLong,
        "distance": distance,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "images": List<dynamic>.from(images!.map((x) => x.toMap())),
        "suggestions": suggestions == null ? null : List<dynamic>.from(suggestions!.map((x) => x.toMap())),
        "user": user?.toMap(),
        "upload_price": uploadPrice,
        "no_of_views": noOfViews,
      };

  static ProductStatus statusToEnum(int status) {
    if (status == 1) {
      return ProductStatus.UNPUBLISHED_PRODUCT_STATUS;
    } else if (status == 2) {
      return ProductStatus.PENDING_APPROVAL_PRODUCT_STATUS;
    } else if (status == 3) {
      return ProductStatus.ACTIVE_PRODUCT_STATUS;
    } else if (status == 4) {
      return ProductStatus.COMPLETED_PRODUCT_STATUS;
    } else if (status == 5) {
      return ProductStatus.DELETED_PRODUCT_STATUS;
    } else if (status == 6) {
      return ProductStatus.BLOCKED_PRODUCT_STATUS;
    } else {
      return ProductStatus.UNPUBLISHED_PRODUCT_STATUS;
    }
  }

  static int statusFromEnum(ProductStatus status) {
    if (status == ProductStatus.UNPUBLISHED_PRODUCT_STATUS) {
      return 1;
    } else if (status == ProductStatus.PENDING_APPROVAL_PRODUCT_STATUS) {
      return 2;
    } else if (status == ProductStatus.ACTIVE_PRODUCT_STATUS) {
      return 3;
    } else if (status == ProductStatus.COMPLETED_PRODUCT_STATUS) {
      return 4;
    } else if (status == ProductStatus.DELETED_PRODUCT_STATUS) {
      return 5;
    } else if (status == ProductStatus.DELETED_PRODUCT_STATUS) {
      return 6;
    } else {
      return 1;
    }
  }
}

class Poster {
  Poster({
    this.userId,
    this.name,
    this.mobileNumber,
    this.address,
    this.profilePhoto,
  });

  final String? userId;
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

//--> Product Status
enum ProductStatus {
  UNPUBLISHED_PRODUCT_STATUS,
  PENDING_APPROVAL_PRODUCT_STATUS,
  ACTIVE_PRODUCT_STATUS,
  COMPLETED_PRODUCT_STATUS,
  DELETED_PRODUCT_STATUS,
  BLOCKED_PRODUCT_STATUS,
}
