// To parse this JSON data, do
//
//     final allFavAdsModel = allFavAdsModelFromJson(jsonString);

import 'dart:convert';

AllFavAdsModel allFavAdsModelFromJson(String str) =>
    AllFavAdsModel.fromJson(json.decode(str));

String allFavAdsModelToJson(AllFavAdsModel data) => json.encode(data.toJson());

class AllFavAdsModel {
  AllFavAdsModel({
    this.data,
    this.status,
    this.message,
  });

  List<FavAdData> data;
  String status;
  String message;

  factory AllFavAdsModel.fromJson(Map<String, dynamic> json) => AllFavAdsModel(
        data: List<FavAdData>.from(
            json["data"].map((x) => FavAdData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class FavAdData {
  FavAdData({
    this.id,
    this.name,
    this.image,
    this.price,
    this.totalRate,
    this.desc,
    this.address,
    this.adType,
    this.country,
    this.city,
    this.isFavourite,
    this.myRate,
    this.adOwner,
    this.category,
    this.currency,
    this.organizationName,
    this.images,
  });

  int id;
  String name;
  String image;
  String price;
  String totalRate;
  String desc;
  dynamic address;
  String adType;
  String organizationName;
  Category country;
  Category city;
  bool isFavourite;
  int myRate;
  AdOwner adOwner;
  Category category;
  Currency currency;
  List<ImageData> images;

  factory FavAdData.fromJson(Map<String, dynamic> json) => FavAdData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        // currency: json["currency"],
        organizationName: json["organization_name"],
        totalRate: json["total_rate"],
        desc: json["desc"],
        address: json["address"],
        adType: json["ad_type"],
        country: Category.fromJson(json["country"]),
        city: Category.fromJson(json["city"]),
        isFavourite: json["is_favourite"],
        myRate: json["my_rate"],
        adOwner: AdOwner.fromJson(json["ad_owner"]),
        category: Category.fromJson(json["category"]),
        currency: Currency.fromJson(json["currency"]),
        images: json["images"] == null
            ? null
            : List<ImageData>.from(
                json["images"].map(
                  (x) => ImageData.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "currency": currency.toJson,
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
  dynamic phone;
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
        "image": image,
        "cover": cover,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
class Currency {
  Currency({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
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
