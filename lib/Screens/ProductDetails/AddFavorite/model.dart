// To parse this JSON data, do
//
//     final addToFavModel = addToFavModelFromJson(jsonString);

import 'dart:convert';

AddToFavModel addToFavModelFromJson(String str) => AddToFavModel.fromJson(json.decode(str));

String addToFavModelToJson(AddToFavModel data) => json.encode(data.toJson());

class AddToFavModel {
    AddToFavModel({
        this.data,
        this.status,
        this.message,
    });

    FavAdvertData data;
    String status;
    String message;

    factory AddToFavModel.fromJson(Map<String, dynamic> json) => AddToFavModel(
        data: FavAdvertData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class FavAdvertData {
    FavAdvertData({
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
        this.images,
    });

    int id;
    String name;
    String image;
    String price;
    dynamic totalRate;
    String desc;
    dynamic address;
    String adType;
    Category country;
    Category city;
    bool isFavourite;
    dynamic myRate;
    AdOwner adOwner;
    Category category;
    List<Image> images;

    factory FavAdvertData.fromJson(Map<String, dynamic> json) => FavAdvertData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
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
        images: json["images"] == null ? null:List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
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