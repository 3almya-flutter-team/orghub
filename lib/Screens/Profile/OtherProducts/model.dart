// To parse this JSON data, do
//
//     final UserAdsModel = UserAdsModelFromJson(jsonString);

import 'dart:convert';

UserAdsModel userAdsModelFromJson(String str) => UserAdsModel.fromJson(json.decode(str));

String userAdsModelToJson(UserAdsModel data) => json.encode(data.toJson());

class UserAdsModel {
    UserAdsModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<UserProductData> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory UserAdsModel.fromJson(Map<String, dynamic> json) => UserAdsModel(
        data: List<UserProductData>.from(json["data"].map((x) => UserProductData.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
        "status": status,
        "message": message,
    };
}

class UserProductData {
    UserProductData({
        this.id,
        this.name,
        this.image,
        this.totalRate,
        this.desc,
        this.address,
        this.adType,
        this.organizationName,
        this.country,
        this.city,
        this.isFavourite,
        this.userRate,
        this.adOwner,
        this.category,
        this.currency,
        this.images,
        this.price,
    });

    int id;
    String name;
    String image;
    String totalRate;
    String desc;
    String organizationName;
    String address;
    String adType;
    Category country;
    Category city;
    bool isFavourite;
    int userRate;
    AdOwner adOwner;
    Category category;
    Currency currency;
    List<Image> images;
    String price;

    factory UserProductData.fromJson(Map<String, dynamic> json) => UserProductData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        totalRate: json["total_rate"],
        organizationName: json["organization_name"],
        desc: json["desc"],
        address: json["address"] == null ? null : json["address"],
        adType: json["ad_type"],
        country: Category.fromJson(json["country"]),
        city: Category.fromJson(json["city"]),
        isFavourite: json["is_favourite"],
        userRate: json["User_rate"],
        adOwner: AdOwner.fromJson(json["ad_owner"]),
        category: Category.fromJson(json["category"]),
        currency: Currency.fromJson(json["currency"]),
        images: json["images"] == null ? null: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        price: json["price"] == null ? null : json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "total_rate": totalRate,
        "desc": desc,
        "address": address == null ? null : address,
        "ad_type": adType,
        "country": country.toJson(),
        "city": city.toJson(),
        "is_favourite": isFavourite,
        "User_rate": userRate,
        "ad_owner": adOwner.toJson(),
        "category": category.toJson(),
        "currency": currency.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "price": price == null ? null : price,
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

class Image {
    Image({
        this.img,
        this.imageId,
    });

    String img;
    int imageId;

    factory Image.fromJson(Map<String, dynamic> json) => Image(
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
