// To parse this JSON data, do
//
//     final singleAdvertModel = singleAdvertModelFromJson(jsonString);

import 'dart:convert';

SingleAdvertModel singleAdvertModelFromJson(String str) =>
    SingleAdvertModel.fromJson(json.decode(str));

String singleAdvertModelToJson(SingleAdvertModel data) =>
    json.encode(data.toJson());

class SingleAdvertModel {
  SingleAdvertModel({
    this.data,
    this.status,
    this.message,
  });

  SingleAdvertData data;
  String status;
  String message;

  factory SingleAdvertModel.fromJson(Map<String, dynamic> json) =>
      SingleAdvertModel(
        data: SingleAdvertData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class SingleAdvertData {
  SingleAdvertData({
    this.id,
    this.name,
    this.image,
    this.totalRate,
    this.desc,
    this.price,
    this.address,
    this.adType,
    this.country,
    this.city,
    this.isFavourite,
    this.myRate,
    this.adOwner,
    this.category,
    this.images,
    this.stock,
    this.createdAt,
    this.adViewsCount,
    this.mark,
    this.specification,
    this.classification,
    this.organizationName,
    this.currency,
    this.tags,
  });

  int id;
  String name;
  String image;
  dynamic totalRate;
  String price;
  String desc;
  String address;
  String adType;
  Category country;
  Category city;
  bool isFavourite;
  dynamic myRate;
  AdOwner adOwner;
  Category category;
  List<ImageData> images;
  int stock;
  DateTime createdAt;
  String adViewsCount;
  Category mark;
  String organizationName;
  Category specification;
  Category classification;
  Category currency;
  List<Tag> tags;

  factory SingleAdvertData.fromJson(Map<String, dynamic> json) =>
      SingleAdvertData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        totalRate: json["total_rate"],
        organizationName: json['organization_name'],
        desc: json["desc"],
        address: json["address"],
        adType: json["ad_type"],
        country: json["country"] == null ? null:Category.fromJson(json["country"]),
        city:    json["city"] == null ? null:Category.fromJson(json["city"]),
        isFavourite: json["is_favourite"],
        myRate: json["my_rate"],
        adOwner: json["ad_owner"] == null? null: AdOwner.fromJson(json["ad_owner"]),
        category:json["category"] == null? null: Category.fromJson(json["category"]),
        images: json["images"] == null
            ? null
            : List<ImageData>.from(
                json["images"].map((x) => ImageData.fromJson(x))),
        stock: json["stock"],
        createdAt: DateTime.parse(json["created_at"]),
        adViewsCount: json["ad_views_count"],
        mark:           json["mark"] == null ? null:Category.fromJson(json["mark"]),
        specification:  json["specification"] == null ? null:Category.fromJson(json["specification"]),
        classification: json["classification"] == null ? null:Category.fromJson(json["classification"]),
        currency:       json["currency"] == null ? null:Category.fromJson(json["currency"]),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "total_rate": totalRate,
        "desc": desc,
        "address": address,
        "ad_type": adType,
        "country": country.toJson(),
        "city": city.toJson(),
        "is_favourite": isFavourite,
        "my_rate": myRate,
        "ad_owner": adOwner.toJson(),
        "category": category.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "stock": stock,
        "created_at":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "ad_views_count": adViewsCount,
        "mark": mark.toJson(),
        "specification": specification.toJson(),
        "classification": classification.toJson(),
        "currency": currency.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
      };
}

class AdOwner {
  AdOwner({
    this.id,
    this.name,
    this.phone,
    this.whatsapp,
    this.image,
    this.cover,
    this.userType,
  });

  int id;
  String name;
  String phone;
  dynamic whatsapp;
  String image;
  String cover;
  String userType;

  factory AdOwner.fromJson(Map<String, dynamic> json) => AdOwner(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        image: json["image"],
        cover: json["cover"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "whatsapp": whatsapp,
        "cover": cover,
        "image": image,
        "user_type": userType,
      };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ImageData {
  ImageData({
    this.img,
    this.imageId,
  });

  String img;
  int imageId;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        img: json["img"],
        imageId: json["image_id"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "image_id": imageId,
      };
}

class Tag {
  Tag({
    this.id,
    this.name,
    this.desc,
    this.adCount,
  });

  int id;
  String name;
  String desc;
  int adCount;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        adCount: json["ad_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "ad_count": adCount,
      };
}
