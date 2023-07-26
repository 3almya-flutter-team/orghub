// To parse this JSON data, do
//
//     final advertsModel = advertsModelFromJson(jsonString);

import 'dart:convert';

AdvertsModel advertsModelFromJson(String str) =>
    AdvertsModel.fromJson(json.decode(str));

String advertsModelToJson(AdvertsModel data) => json.encode(data.toJson());

class AdvertsModel {
  AdvertsModel({
    this.adverts,
    this.links,
    this.meta,
    this.status,
    this.message,
  });

  List<AdvertData> adverts;
  Links links;
  Meta meta;
  String status;
  String message;

  factory AdvertsModel.fromJson(Map<String, dynamic> json) => AdvertsModel(
        adverts: List<AdvertData>.from(
            json["data"].map((x) => AdvertData.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(adverts.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
        "status": status,
        "message": message,
      };
}

class AdvertData {
  AdvertData({
    this.id,
    this.name,
    this.image,
    this.price,
    this.totalRate,
    this.desc,
    this.adType,
    this.country,
    this.city,
    this.isFavourite,
    this.myRate,
    this.adOwner,
    this.category,
    this.currency,
    this.images,
    this.organizationName,
  });

  int id;
  String name;
  String image;
  String price;
  dynamic totalRate;
  String desc;
  String adType;
  String organizationName;
  Category country;
  Category city;
  bool isFavourite;
  dynamic myRate;
  AdOwner adOwner;
  Category category;
  Currency currency;
  List<ImageData> images;

  factory AdvertData.fromJson(Map<String, dynamic> json) => AdvertData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        organizationName: json['organization_name'],
        price: json["price"],
        // currency: json["currency"],
        totalRate: json["total_rate"],
        desc: json["desc"],
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
                json["images"].map((x) => ImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        // "currency": currency,
        "total_rate": totalRate,
        "desc": desc,
        "ad_type": adType,
        "country": country.toJson(),
        "city": city.toJson(),
        "is_favourite": isFavourite,
        "my_rate": myRate,
        "ad_owner": adOwner.toJson(),
        "category": category.toJson(),
        "currency": currency.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class AdOwner {
  AdOwner({
    this.id,
    this.name,
    this.image,
    this.userType,
  });

  int id;
  String name;
  String image;
  String userType;

  factory AdOwner.fromJson(Map<String, dynamic> json) => AdOwner(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "user_type": userType,
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
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String first;
  String last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
